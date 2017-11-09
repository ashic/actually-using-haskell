{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( someFunc
    ) where

import Model

someFunc :: IO ()
someFunc = putStrLn $ 
           show $ 
           toDo ("something", "description of something")
