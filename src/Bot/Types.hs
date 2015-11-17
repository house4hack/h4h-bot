{-# LANGUAGE OverloadedStrings #-}
 module Bot.Types where

import Data.Aeson
import Control.Applicative

data Update = Update
  { updateId      :: Int
  , updateMessage :: Message
  } deriving (Show)

-- instance FromJSON Person where
--     parseJSON (Object v) = Person <$>
--                            v .: "name" <*>
--                            v .: "age"
--     -- A non-Object value is of the wrong type, so fail.
--     parseJSON _          = empty

data Message = Message
  { messageId   :: Int
  , messageFrom :: User
  , messageDate :: Int
  , messageChat :: Chat

  -- These are some of the optional parameters.
  --
  -- , messageForwardFrom :: User
  -- , messageForwardDate :: Int
  -- , messageReplyToMessage :: Message
  -- , messageText :: String
  -- , messageAudio :: Audio
  -- , messageDocument :: Document
  } deriving (Show)

data User = User
  { userId        :: Int
  , userFirstName :: String
  , userLastName  :: String
  , username      :: String
  } deriving (Show)

data Chat = Chat
  { chatId        :: Int
  , chatType      :: String
  , chatTitle     :: String
  , chatUsername  :: String
  , chatFirstName :: String
  , chatLastName  :: String
  } deriving (Show)
