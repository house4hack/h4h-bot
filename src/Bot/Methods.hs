module Bot.Methods where

import Data.Aeson
import Data.ByteString.Lazy (ByteString)
import Data.Monoid ((<>))
import Network.HTTP.Client
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Data.Text (unpack)
import Bot.Config

endpoint :: Config -> String
endpoint (Config token) = "https://api.telegram.org/bot" <> token <>"/"

getUpdates :: Maybe Int -> Maybe Int -> Maybe Int -> String
getUpdates offset limit timeout = "getUpdates"
  -- "getUpdates" <> "?offset=" <> offset
  --              <> "&limit="  <> limit
  --              <> "&timeout=" <> timeout

runMethod :: Config -> String -> IO ()
runMethod cfg method = do
  manager <- tlsManager
  putStrLn $ endpoint cfg <> method
  request <- parseUrl $ endpoint cfg <> method
  response <- httpLbs request manager
  putStrLn $ show $ responseBody response

tlsManager :: IO Manager
tlsManager = newManager tlsManagerSettings
