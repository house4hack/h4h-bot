module Bot (start) where

import Bot.Commands       (handleUpdate)
import Bot.Config         (loadConfig)
import Bot.Methods        (Manager, tlsManager, getUpdates)
import Bot.Types          (Config, UpdateId, updateId)
import Control.Exception  (SomeException, catch)
import Control.Concurrent (threadDelay)

-- | Load config and process updates. Get a new http manager and try
-- again if an exception breaks the processUpdates loop.
start :: IO ()
start = do
  cfg <- loadConfig
  http <- tlsManager
  catch (processUpdates cfg http Nothing) logException

-- | Fetch batches of updates and handle them.
processUpdates :: Config -> Manager -> Maybe UpdateId -> IO ()
processUpdates cfg http moffset = do
  updates <- getUpdates cfg http moffset
  if null updates
     then processUpdates cfg http moffset
     else do
       mapM_ (handleUpdate cfg http) updates
       processUpdates cfg http $ Just $ (+1) $ updateId $ last updates

-- | Log exception and wait five seconds before retrying.
logException :: SomeException -> IO ()
logException e = do
  print e
  threadDelay (5 * 1000 * 5000)
