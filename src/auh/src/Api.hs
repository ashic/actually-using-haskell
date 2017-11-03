{-# LANGUAGE OverloadedStrings #-}
module Api
    ( whatsTheTime,
      getToDos  
    ) where

import Data.Time (getCurrentTime)
import Model
import DB
import Database.CQL.Protocol
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