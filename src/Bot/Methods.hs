{-# LANGUAGE OverloadedStrings, CPP #-}
module Bot.Methods
  ( module Bot.Methods
  , Manager
  ) where

import Bot.Types
import Data.ByteString.Lazy.Char8 (unpack)
import Data.Monoid ((<>))
import Network.HTTP.Client
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Text.JSON
#if __GLASGOW_HASKELL__ < 710
import Control.Applicative ((<$>))
#endif

endpoint :: Config -> String
endpoint cfg = "https://api.telegram.org/bot" <> cfgToken cfg <>"/"

timeoutSeconds :: Int
timeoutSeconds = 60

getMe :: Config -> Manager -> IO User
getMe cfg http = do
  body <- getUrl cfg http "getMe"
  handleBody "getMe" body

getUpdates :: Config -> Manager -> Maybe UpdateId -> IO [Update]
getUpdates cfg http moffset = do
  body <- getUrl cfg http $ case moffset of
                              Nothing -> "getUpdates?timeout=" <> show timeoutSeconds
                              Just (UpdateId i) -> "getUpdates?timeout=" <> show timeoutSeconds <>"&offset="<> show i
  handleBody "getUpdates" body

sendMessage :: Config -> Manager -> Int -> String -> IO Message
sendMessage cfg http cid te = do
  body <- getUrl cfg http $ "sendMessage?chat_id=" <> show cid <> "&text=" <> te
  handleBody "sendMessage" body

handleBody :: JSON a => String -> String -> IO a
handleBody fname body =
  case result <$> decode body of
   Ok payload -> return payload
   Error s    -> error $ fname <> ": " <> s

getUrl :: Config -> Manager -> String -> IO String
getUrl cfg http meth = do
  let url = endpoint cfg <> meth
  putStrLn url
  request <- parseUrlThrow url
  response <- httpLbs request http
  return $ unpack $ responseBody response

-- Connection timeout should be greater than timeout in query param.
tlsManager :: IO Manager
tlsManager = newManager $ tlsManagerSettings { managerResponseTimeout = t }
  where t = responseTimeoutMicro (timeoutSeconds * 1000000)
