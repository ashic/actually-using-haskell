{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module Main where

import Handlers
import DB
import Model
import Audit
import Web.Scotty
import Control.Monad.IO.Class
import Control.Monad
import Control.Exception
import Data.String
import Data.Text
import Data.Aeson (FromJSON, ToJSON)
import qualified System.Logger as Logger
import Database.CQL.IO as Client
import Database.CQL.Protocol hiding (pack)

routes c audit = do 
    get "/" $ do
        record "access" "GET /" audit
        res <- liftIO whatsTheTime
        text $ fromString res
    
    get "/hello" $ text "hello"

    get "/todos" $ do
        record "access" "GET /todos" audit
        items <- liftIO $ getToDos c
        json items
    
    get "/todos/:p" $ do
        p <- param "p"
        record "access" ("GET /todos/" ++ p) audit
        items <- liftIO $ getToDo (fromString p) c
        json items

    put "/todos" $ do
        record "access" "PUT /todos/" audit
        item <- jsonData :: ActionM ToDo
        _ <- liftIO $ upsertToDo item c
        text "saved successfully"



main :: IO ()
main = bracket setup teardown $ (\mp -> do
    -- <- fmap (\(a, c) -> scotty 3000 $ routes c) mp
        let (a, c) = mp
        _ <- 
            case a of 
                Right audit -> scotty 3000 $ routes c audit
                _ -> putStrLn "Failed to connect to Kafka"
        return ()
    )
    where 
        setup = do
            a <- liftIO initAudit
            c <- liftIO connect
            return (a, c)
        teardown (mk, _) = do
            _ <- putStrLn "shutting down."
            case mk of
                Right k -> closeAudit k
                _ -> return ()
            return ()