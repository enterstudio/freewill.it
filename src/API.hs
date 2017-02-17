{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DeriveGeneric #-}

module API where

import Data.Aeson
import Data.Aeson.TH
import Data.Text (unpack)
import Servant
import Data.Swagger
import GHC.Generics
import Util

data User = User
  { userId        :: Int
  , userFirstName :: String
  , userLastName  :: String
  } deriving (Eq, Show, Generic)

instance ToSchema User

$(deriveJSON defaultOptions ''User)

type API = "signup"  :> Post '[JSON] [User]
      :<|> "signin"  :> Post '[JSON] [User]
      :<|> "signout" :> Post '[JSON] [User]
      :<|> "name"    :> ReqBody '[JSON, PlainText] String :> Post '[JSON] [User]
      :<|> "add"     :> Post '[JSON] [User]
      :<|> "view"    :> Get  '[JSON] [User]
      :<|> "choose"  :> Post '[JSON] [User]
      :<|> Redirect "view"

help :: IO ()
help = putStrLn $ Data.Text.unpack $ layout  (Proxy :: Proxy API)
