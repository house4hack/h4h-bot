module Bot.Methods where

import Bot.Types
import Data.Aeson
import Data.ByteString.Lazy (ByteString)
import Data.Monoid ((<>))
import Network.HTTP.Client
import Network.HTTP.Client.TLS (tlsManagerSettings)

endpoint :: Config -> String
endpoint cfg = "https://api.telegram.org/bot" <> cfgToken cfg <>"/"

getMe :: Config -> IO User
getMe cfg = do
  body <- getUrl cfg "getMe"
  case result <$> decode body of
   Just user -> return user
   Nothing      -> error "getMe: failed to parse response"

getUpdates :: Config -> Maybe UpdateId -> IO [Update]
getUpdates cfg moffset = do
  body <- getUrl cfg $ case moffset of
                          Nothing -> "getUpdates"
                          Just (UpdateId i) -> "getUpdates?offset=" <> show i
  case result <$> decode body of
   Just updates -> return updates
   Nothing      -> error "getUpdates: failed to parse response"

sendMessage :: Config -> Int -> String -> IO Message
sendMessage cfg cid te = do
  body <- getUrl cfg $ "sendMessage?chat_id=" <> show cid <> "&text=" <> te
  case result <$> decode body of
   Just messages -> return messages
   Nothing       -> error "sendMessage: failed to parse response"

getUrl :: Config -> String -> IO ByteString
getUrl cfg meth = do
  let url = endpoint cfg <> meth
  putStrLn url
  request <- parseUrl url
  response <- httpLbs request =<< tlsManager
  return $ responseBody response

tlsManager :: IO Manager
tlsManager = newManager tlsManagerSettings
