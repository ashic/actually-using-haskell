{-# LANGUAGE OverloadedStrings #-}

module Main where

import Model
import Handlers
import Control.Monad.IO.Class
import Control.Exception
import Data.String
import Web.Scotty
import DB
import Audit

routes c audit = do

    get "/hello" $ text "hello"

    get "/hello/:name" $ do
        name <- param "name"
        record "access" ("GET /hello/" ++ name) audit
        text $ fromString $ "Hello " ++ name

    get "/time" $ do
        record "access" "GET /time" audit
        res <- liftIO whatsTheTime
        text $ fromString res

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
