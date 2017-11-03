{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module Main where

import Api
import DB
import Web.Scotty
import Control.Monad.IO.Class
import Control.Monad
import Data.String
import Data.Text
import Data.Aeson (FromJSON, ToJSON)
import qualified System.Logger as Logger
import Database.CQL.IO as Client
import Database.CQL.Protocol

routes c = do 
    get "/" $ do
        res <- liftIO whatsTheTime
        text $ fromString res
    
    get "/hello" $ text "hello"

    get "/todos" $ do
        items <- liftIO $ getToDos c
        json items



main :: IO ()
main = do
    c <- connect
    
    --res <- runClient c $ query ("SELECT id, description from todos.todos;":: QueryString R() (Text, Text)) $ cqlParams ()
    -- res <- getToDos c
    -- print res
    scotty 3000 $ routes c
