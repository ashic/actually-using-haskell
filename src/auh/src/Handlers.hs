{-# LANGUAGE OverloadedStrings #-}
module Handlers
    ( whatsTheTime
    ) where

import Data.Time (getCurrentTime)

whatsTheTime :: IO String
whatsTheTime = do
    time <- getCurrentTime
    return $ "The time is now " ++ show time 
    