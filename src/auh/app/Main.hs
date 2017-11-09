{-# LANGUAGE OverloadedStrings #-}

module Main where

import Model
import Data.String
import Web.Scotty

routes = do

    get "/hello" $ text "hello"

    get "/hello/:name" $ do
        name <- param "name"
        text $ fromString $ "Hello " ++ name

main :: IO ()
main = scotty 3000 routes