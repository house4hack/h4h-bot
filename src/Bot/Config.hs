module Bot.Config where

import System.Environment


getConfig :: IO Config
getConfig = Config <$> getEnv "H4H_BOT_TOKEN"

data Config = Config
  { cfgToken :: String
  } deriving (Show)
