{-# LANGUAGE OverloadedStrings #-}
module Bot.Config
 ( loadConfig
 ) where

import Bot.Types
import Data.Configurator

loadConfig :: IO Config
loadConfig = do
  f <- load [ Required "bot.cfg" ]
  Config <$> require f "bot.token"
         <*> require f "access.group"
         <*> require f "access.door"
         <*> require f "access.gate"
