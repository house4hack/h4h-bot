module Main where

import Bot.Config
import Bot.Methods (runMethod)

main :: IO ()
main = do
  cfg <- getConfig
  runMethod cfg "getUpdates"
