{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Model
     where

import GHC.Generics
import Data.Aeson (FromJSON, ToJSON)
import Data.Text

data ToDo = ToDo {id :: Text, description :: Text} deriving (
    Show, Generic)
instance ToJSON ToDo
instance FromJSON ToDo

toDo (identifier, description) = 
    ToDo {Model.id=identifier, description=description}
tupleFromToDo item = (Model.id item, description item)