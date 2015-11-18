module Main where

import Bot.Config
import Bot.Methods
import Bot.Types
import Data.Maybe
import Control.Monad

main :: IO ()
main = do
  cfg <- loadConfig
  echo cfg Nothing

-- | echoes back what it receives.
echo :: Config -> Maybe UpdateId -> IO ()
echo cfg moffset = do
  updates <- getUpdates cfg moffset
  if null updates
     then echo cfg moffset
     else do
       mapM_ (respondToMessage cfg) updates
       echo cfg $ Just $ incUpdateId $ updateId $ last updates

incUpdateId :: UpdateId -> UpdateId
incUpdateId (UpdateId i) = UpdateId (1 + i)


respondToMessage :: Config -> Update -> IO ()
respondToMessage cfg (Update _ (Message _ _ _ chat mtext)) =
  void $ sendMessage cfg (chatId chat) (fromMaybe "no message" mtext)
