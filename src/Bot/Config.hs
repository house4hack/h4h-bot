{-# LANGUAGE OverloadedStrings, CPP #-}
module Bot.Config
 ( loadConfig
 ) where

import Bot.Types
import Data.Configurator
#if __GLASGOW_HASKELL__ < 710
import Control.Applicative ((<$>), (<*>))
#endif

loadConfig :: IO Config
loadConfig = do
  f <- load [ Required "/etc/h4h-bot.cfg" ]
  Config <$> require f "bot.token"
         <*> require f "access.group"
         <*> require f "access.door"
         <*> require f "access.gate"
