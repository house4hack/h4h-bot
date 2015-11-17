module Main where

import Bot.Config
import Bot.Methods

main :: IO ()
main = do
  cfg <- getConfig
  print =<< getUpdates cfg
