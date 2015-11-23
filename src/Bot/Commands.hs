module Bot.Commands where

import Bot.Types
import Bot.Methods
import Control.Monad
import Network.HTTP.Client

helpText :: String
helpText = "I can grant access to h4h with\
           \ the command `/open door` or `/open gate`"

isAuthenticated :: Config -> Chat -> Bool
isAuthenticated cfg chat = chatId chat == cfgAccess cfg

handleUpdate :: Config -> Manager -> Update -> IO ()
handleUpdate cfg http (Update _ (Message _ _ _ chat mtext)) =
  let respond msg = void $ sendMessage cfg http (chatId chat) msg in
    case mtext of
      Just "/start"     -> respond "start text"
      Just "/help"      -> respond helpText
      Just "/settings"  -> respond "settings text"
      Just "/open door" ->
        if isAuthenticated cfg chat then
          do respond "Attempting to open door..."
             access http $ cfgDoor cfg
          else respond "Sorry, only works from the House4Hack Access group."

      Just "/open gate" ->
        if isAuthenticated cfg chat then
          do respond "Attempting to open gate..."
             access http $ cfgGate cfg
          else respond "Sorry, only works from the House4Hack Access group."

      Just echo         -> respond echo
      _                 -> respond "nothing text"

access :: Manager -> String -> IO ()
access http url = void $ flip httpLbs http =<< parseUrl url
