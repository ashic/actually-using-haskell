{-# LANGUAGE OverloadedStrings #-}

module Main where

import Model
import Handlers
import Control.Monad.IO.Class
import Data.String
import Web.Scotty

routes = do

    get "/hello" $ text "hello"

    get "/hello/:name" $ do
        name <- param "name"
        text $ fromString $ "Hello " ++ name

    get "/time" $ do
        res <- liftIO whatsTheTime
        text $ fromString res

main :: IO ()
main = scotty 3000 routes