{-# LANGUAGE OverloadedStrings #-}
module Bot.Types where

import Text.JSON
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

instance JSON a => JSON (BotResponse a) where
  readJSON (JSObject v) = BotResponse <$> valFromObj "result" v
  readJSON _            = empty


newtype UpdateId = UpdateId Int deriving (Show)

data Update = Update
  { updateId      :: UpdateId
  , updateMessage :: Message
  } deriving (Show)

instance JSON Update where
  readJSON (JSObject v) =
    Update <$> (UpdateId <$> valFromObj "update_id" v)
           <*> valFromObj "message" v
  readJSON _ = empty


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

instance JSON Message where
  readJSON (JSObject v) =
    Message <$> valFromObj "message_id" v
            <*> maybeFromObj "from" v
            <*> valFromObj "date" v
            <*> valFromObj "chat" v
            <*> maybeFromObj "text" v
  readJSON _ = empty


data User = User
  { userId        :: Int
  , userFirstName :: String
  , userLastName  :: Maybe String
  , username      :: Maybe String
  } deriving (Show)

instance JSON User where
  readJSON (JSObject v) =
    User <$> valFromObj "id" v
         <*> valFromObj "first_name" v
         <*> maybeFromObj "last_name" v
         <*> maybeFromObj "username" v
  readJSON _ = empty

data Chat = Chat
  { chatId        :: Int
  , chatType      :: String
  , chatTitle     :: Maybe String
  , chatUsername  :: Maybe String
  , chatFirstName :: Maybe String
  , chatLastName  :: Maybe String
  } deriving (Show)

instance JSON Chat where
  readJSON (JSObject v) =
    Chat <$> valFromObj "id" v
         <*> valFromObj "type" v
         <*> maybeFromObj "title" v
         <*> maybeFromObj "username" v
         <*> maybeFromObj "first_name" v
         <*> maybeFromObj "last_name" v
  readJSON _ = empty

maybeFromObj :: JSON a => String -> JSObject JSValue -> Result (Maybe a)
maybeFromObj k o = maybe (Ok Nothing)
  (\js -> Just <$> readJSON js) (lookup k (fromJSObject o))


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
