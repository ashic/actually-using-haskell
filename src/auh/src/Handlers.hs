{-# LANGUAGE OverloadedStrings #-}
module Handlers
    ( whatsTheTime,
      getToDo,
      getToDos,
      upsertToDo
    ) where

import Data.Time (getCurrentTime)
import Data.Text hiding (map)
import Control.Monad.Identity
import Database.CQL.Protocol
import Database.CQL.IO
import Model
import DB


whatsTheTime :: IO String
whatsTheTime = do
    time <- getCurrentTime
    return $ "The time is now " ++ show time 
   
getToDos db =
    map toDo <$>
    cqlQuery ("SELECT id, description from todos.todos;" 
        :: QueryString R() (Text, Text)) () db

getToDos2 db = do
    arr <- cqlQuery ("SELECT id, description from todos.todos;" :: QueryString R() (Text, Text)) () db
    return $ map toDo arr

getToDo identifier db =
    fmap toDo <$>
    cqlQuery1 ("SELECT id, description from todos.todos where id=?;" 
        :: QueryString R (Identity Text) (Text, Text)) identifier  db

upsertToDo item = 
    cqlWrite1  ("INSERT INTO todos.todos (id, description) values (?, ?);" 
        :: QueryString W (Text, Text) ()) $ tupleFromToDo item

upsertToDo2 item db = 
    cqlWrite1  ("INSERT INTO todos.todos (id, description) values (?, ?);" :: QueryString W (Text, Text) ()) (tupleFromToDo item) db
