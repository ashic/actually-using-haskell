{-# LANGUAGE OverloadedStrings #-}

module Main where

import Model
import Handlers
import Control.Monad.IO.Class
import Data.String
import Web.Scotty
import DB

routes c = do

    get "/hello" $ text "hello"

    get "/hello/:name" $ do
        name <- param "name"
        text $ fromString $ "Hello " ++ name

    get "/time" $ do
        res <- liftIO whatsTheTime
        text $ fromString res

    get "/todos" $ do
        items <- liftIO $ getToDos c
        json items
    
    get "/todos/:p" $ do
        p <- param "p"
        items <- liftIO $ getToDo (fromString p) c
        json items

    put "/todos" $ do
        item <- jsonData :: ActionM ToDo
        _ <- liftIO $ upsertToDo item c
        text "saved successfully"

main :: IO ()
main = do
    c <- liftIO connect
    scotty 3000 $ routes c