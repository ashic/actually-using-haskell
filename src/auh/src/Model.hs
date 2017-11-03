{-# LANGUAGE DeriveGeneric #-}

module Model
     where

import GHC.Generics
import Data.Aeson (FromJSON, ToJSON)
import Data.Text

data ToDo = ToDo {id :: Text, description :: Text} deriving (
    Show, Generic)
instance ToJSON ToDo
instance FromJSON ToDo

toDo (identifier, description) = ToDo {Model.id=identifier, description=description}