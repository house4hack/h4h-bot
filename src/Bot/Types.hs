{-# LANGUAGE OverloadedStrings #-}
module Bot.Types where

import Data.Aeson
import Control.Applicative

type ChatId = (String, Int)

data Config = Config
  { cfgToken  :: String
  , cfgGroup :: Int
  , cfgDoor   :: String
  , cfgGate   :: String
  } deriving Show

newtype BotResponse a =
  BotResponse { result :: a } deriving Show

instance FromJSON a => FromJSON (BotResponse a) where
  parseJSON (Object v) = BotResponse <$> v .: "result"
  parseJSON _          = empty


newtype UpdateId = UpdateId Int deriving (Show)

data Update = Update
  { updateId      :: UpdateId
  , updateMessage :: Message
  } deriving (Show)

instance FromJSON Update where
  parseJSON (Object v) =
    Update <$> (UpdateId <$> v .: "update_id")
           <*> v .: "message"
  parseJSON _ = empty


data Message = Message
  { messageId   :: Int
  , messageFrom :: Maybe User
  , messageDate :: Int
  , messageChat :: Chat
  , messageText :: Maybe String

  -- These are some of the optional parameters.
  --
  -- , messageForwardFrom :: User
  -- , messageForwardDate :: Int
  -- , messageReplyToMessage :: Message
  -- , messageAudio :: Audio
  -- , messageDocument :: Document
  } deriving (Show)

instance FromJSON Message where
  parseJSON (Object v) =
    Message <$> v .:  "message_id"
            <*> v .:? "from"
            <*> v .:  "date"
            <*> v .:  "chat"
            <*> v .:? "text"
  parseJSON _ = empty


data User = User
  { userId        :: Int
  , userFirstName :: String
  , userLastName  :: Maybe String
  , username      :: Maybe String
  } deriving (Show)

instance FromJSON User where
  parseJSON (Object v) =
    User <$> v .:  "id"
         <*> v .:  "first_name"
         <*> v .:? "last_name"
         <*> v .:? "username"
  parseJSON _ = empty

data Chat = Chat
  { chatId        :: Int
  , chatType      :: String
  , chatTitle     :: Maybe String
  , chatUsername  :: Maybe String
  , chatFirstName :: Maybe String
  , chatLastName  :: Maybe String
  } deriving (Show)

instance FromJSON Chat where
  parseJSON (Object v) =
    Chat <$> v .:  "id"
         <*> v .:  "type"
         <*> v .:? "title"
         <*> v .:? "username"
         <*> v .:? "first_name"
         <*> v .:? "last_name"
  parseJSON _ = empty



data OnlyTrue = True deriving (Show)

data ReplyMarkup
  = ReplyKeyboardMarkup
      { rmKeyboard        :: [[String]]
      , rmResizeKeyboad   :: Maybe Bool
      , rmOneTimeKeyboard :: Maybe Bool
      , rmSelective       :: Maybe Bool
      }
  | ReplyKeyboardHide
      { rmHideKeyboard :: OnlyTrue
      , rmSelective    :: Maybe Bool
      }
  | ForceReply
      { rmForceReply :: OnlyTrue
      , rmSelective  :: Maybe Bool
      } deriving (Show)
