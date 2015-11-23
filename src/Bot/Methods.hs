{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GADTs #-}
module Bot.Methods
  ( module Bot.Methods
  , Manager
  ) where

import Bot.Types
import Data.Aeson
import Data.ByteString.Lazy (ByteString)
import Data.Monoid ((<>))
import Network.HTTP.Client
import Network.HTTP.Client.TLS (tlsManagerSettings)

endpoint :: Config -> String
endpoint cfg = "https://api.telegram.org/bot" <> cfgToken cfg <>"/"

timeoutSeconds :: Int
timeoutSeconds = 60

getMe :: Config -> Manager -> IO User
getMe cfg http = do
  body <- getUrl cfg http "getMe"
  case result <$> decode body of
   Just user -> return user
   Nothing      -> error "getMe: failed to parse response"

getUpdates :: Config -> Manager -> Maybe UpdateId -> IO [Update]
getUpdates cfg http moffset = do
  body <- getUrl cfg http $ case moffset of
                              Nothing -> "getUpdates?timeout=" <> show timeoutSeconds
                              Just (UpdateId i) -> "getUpdates?timeout=" <> show timeoutSeconds <>"&offset="<> show i
  case result <$> decode body of
   Just updates -> return updates
   Nothing      -> error "getUpdates: failed to parse response"

sendMessage :: Config -> Manager -> Int -> String -> IO Message
sendMessage cfg http cid te = do
  body <- getUrl cfg http $ "sendMessage?chat_id=" <> show cid <> "&text=" <> te
  case result <$> decode body of
   Just messages -> return messages
   Nothing       -> error "sendMessage: failed to parse response"

getUrl :: Config -> Manager -> String -> IO ByteString
getUrl cfg http meth = do
  let url = endpoint cfg <> meth
  putStrLn url
  request <- parseUrl url
  response <- httpLbs request http
  return $ responseBody response

tlsManager :: IO Manager
tlsManager = newManager $ tlsManagerSettings { managerResponseTimeout = timeout }
  where timeout = Just $ timeoutSeconds * 1000000
