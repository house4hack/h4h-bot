module Main where

import Bot.Commands
import Bot.Config
import Bot.Methods
import Bot.Types
import Control.Monad (forever)

-- | Load config and process updates. Get a new http manager and try
-- again if an exception breaks the processUpdates loop.
main :: IO ()
main = do
  cfg <- loadConfig
  forever $ do
    http <- tlsManager
    processUpdates cfg http Nothing

-- | Fetch batches of updates and handle them.
processUpdates :: Config -> Manager -> Maybe UpdateId -> IO ()
processUpdates cfg http moffset = do
  updates <- getUpdates cfg http moffset
  if null updates
     then processUpdates cfg http moffset
     else do
       mapM_ (handleUpdate cfg http) updates
       processUpdates cfg http $ Just $ (+1) $ updateId $ last updates
