{-# LANGUAGE OverloadedStrings #-}
module Api
    ( whatsTheTime,
      getToDos,
      getToDo  
    ) where

import Data.Time (getCurrentTime)
import Control.Monad.Identity
import Control.Monad.IO.Class
import Model
import DB
import Database.CQL.Protocol
import Database.CQL.IO

import Data.Text hiding (map)

whatsTheTime :: IO String
whatsTheTime = do
    time <- getCurrentTime
    return $ "The time is now " ++ show time 
    
allToDos :: [ToDo]
allToDos = 
    [
        toDo ("One", "Check in some code."),
        toDo ("Two", "Go home.")
    ]

getToDos2 db = do
    arr <- cqlQuery ("SELECT id, description from todos.todos;" :: QueryString R() (Text, Text)) () db
    return $ map toDo arr
    
getToDos db =
    map toDo <$>
    cqlQuery ("SELECT id, description from todos.todos;" :: QueryString R() (Text, Text)) () db

getToDo identifier db =
    fmap toDo <$>
    cqlQuery1 ("SELECT id, description from todos.todos where id=?;" :: QueryString R (Identity Text) (Text, Text)) identifier  db