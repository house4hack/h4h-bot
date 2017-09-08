module Bot.Commands where

import Bot.Types
import Bot.Methods
import Control.Monad
import Network.HTTP.Client
import System.Process (readProcess)
import Data.Time.Clock.POSIX
#if __GLASGOW_HASKELL__ < 710
import Control.Applicative ((<$>))
#endif

type Posix = Int

helpText :: String
helpText = "I can grant access to h4h with the command `/door` or `/gate`"

isAuthenticated :: Config -> Chat -> Bool
isAuthenticated cfg chat = chatId chat == cfgGroup cfg

isTimely :: Config -> Posix -> IO Bool
isTimely cfg t0 = do
  t1 <- round <$> getPOSIXTime
  return $ t1 - t0 < cfgTimeout cfg

handleUpdate :: Config -> Manager -> Update -> IO ()
handleUpdate cfg http (Update _ (Message _ _ t chat mtext)) = do

  -- silently ignore untimely messages.
  timely <- isTimely cfg t
  when timely $ do
    let respond msg  = void $ sendMessage cfg http (chatId chat) msg
        tryDoor = if isAuthenticated cfg chat then
          do respond "Attempting to open door..."
             access http $ cfgDoor cfg
          else respond "Sorry, only works from the House4Hack Access group."
        tryGate = if isAuthenticated cfg chat then
          do respond "Attempting to open gate..."
             access http $ cfgGate cfg
          else respond "Sorry, only works from the House4Hack Access group."
        hostname = do
          s <- readProcess "hostname" ["-I"] []
          respond $ "IP addresses: " ++ take (length s - 2) s
    case mtext of
      Just "/start"       -> respond helpText
      Just "/help"        -> respond helpText
      Just "/settings"    -> respond "settings text"
      Just "/door"        -> tryDoor
      Just "/door@h4hBot" -> tryDoor
      Just "/gate"        -> tryGate
      Just "/gate@h4hBot" -> tryGate
      Just "/hostname"    -> hostname
      _                   -> respond "I'm the h4h access bot"

access :: Manager -> String -> IO ()
access http url = void $ flip httpLbs http =<< parseUrlThrow url
