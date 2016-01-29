module Bot.Commands where

import Bot.Types
import Bot.Methods
import Control.Monad
import Network.HTTP.Client
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

    case mtext of
      Just "/start"     -> respond "start text"
      Just "/help"      -> respond helpText
      Just "/settings"  -> respond "settings text"
      Just "/door" ->
        if isAuthenticated cfg chat then
          do respond "Attempting to open door..."
             access http $ cfgDoor cfg
          else respond "Sorry, only works from the House4Hack Access group."

      Just "/gate" ->
        if isAuthenticated cfg chat then
          do respond "Attempting to open gate..."
             access http $ cfgGate cfg
          else respond "Sorry, only works from the House4Hack Access group."

      Just echo         -> respond echo
      _                 -> respond "nothing text"

access :: Manager -> String -> IO ()
access http url = void $ flip httpLbs http =<< parseUrl url
