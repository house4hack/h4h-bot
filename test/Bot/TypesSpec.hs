module Bot.TypesSpec where

import Bot.Types
import Test.Hspec
import Text.JSON

spec :: Spec
spec = do
  describe "parseJson instances" $ do
    it "decodes updates" $ do
      updates <- readFile "test/Bot/data/updates.json"
      length <$> (decode updates :: (Result [Update])) `shouldBe` Ok 9
    it "decodes chats" $ do
      chats <- readFile "test/Bot/data/chats.json"
      length <$> (decode chats :: (Result [Chat])) `shouldBe` Ok 1
    it "decodes users" $ do
      users <- readFile "test/Bot/data/users.json"
      length <$> (decode users :: (Result [User])) `shouldBe` Ok 1
    it "decodes messages" $ do
      messages <- readFile "test/Bot/data/messages.json"
      length <$> (decode messages :: (Result [Message])) `shouldBe` Ok 2
