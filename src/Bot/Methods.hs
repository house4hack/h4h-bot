module Bot.Methods where

import Bot.Config
import Bot.Types
import Data.Aeson
import Data.ByteString.Lazy (ByteString)
import Data.Monoid ((<>))
import Network.HTTP.Client
import Network.HTTP.Client.TLS (tlsManagerSettings)

endpoint :: Config -> String
endpoint (Config token) = "https://api.telegram.org/bot" <> token <>"/"

getUpdates :: Config -> IO [Update]
getUpdates cfg = do
  body <- getUrl cfg "getUpdates"
  case botResult <$> decode body of
   Just updates -> return updates
   Nothing      -> error "getUpdates: failed to parse response"

getUrl :: Config -> String -> IO ByteString
getUrl cfg meth = do
  let url = endpoint cfg <> meth
  putStrLn url
  request <- parseUrl url
  response <- httpLbs request =<< tlsManager
  return $ responseBody response

tlsManager :: IO Manager
tlsManager = newManager tlsManagerSettings
