module Bot.TypesSpec where

import Bot.Types
import Test.Hspec
import qualified Data.ByteString.Lazy as LBS
import Data.Aeson

spec :: Spec
spec = do
  describe "parseJson instances" $ do
    it "decodes updates" $ do
      updates <- LBS.readFile "test/Bot/data/updates.json"
      length <$> (decode updates :: (Maybe [Update])) `shouldBe` Just 9
    it "decodes chats" $ do
      chats <- LBS.readFile "test/Bot/data/chats.json"
      length <$> (decode chats :: (Maybe [Chat])) `shouldBe` Just 1
    it "decodes users" $ do
      users <- LBS.readFile "test/Bot/data/users.json"
      length <$> (decode users :: (Maybe [User])) `shouldBe` Just 1
    it "decodes messages" $ do
      messages <- LBS.readFile "test/Bot/data/messages.json"
      length <$> (decode messages :: (Maybe [Message])) `shouldBe` Just 1
