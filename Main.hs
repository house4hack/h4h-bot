module Main where

import Bot.Commands
import Bot.Config
import Bot.Methods
import Bot.Types
-- import Control.Monad

main :: IO ()
main = do
  cfg <- loadConfig
  http <- tlsManager
  echo cfg http Nothing

-- | echoes back what it receives.
echo :: Config -> Manager -> Maybe UpdateId -> IO ()
echo cfg http moffset = do
  updates <- getUpdates cfg http moffset
  if null updates
     then echo cfg http moffset
     else do
       mapM_ (handleUpdate cfg http) updates
       echo cfg http $ Just $ incUpdateId $ updateId $ last updates

incUpdateId :: UpdateId -> UpdateId
incUpdateId (UpdateId i) = UpdateId (1 + i)
