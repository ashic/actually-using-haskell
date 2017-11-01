module Foo
    ( someFunc
    ) where

import Data.Time (getCurrentTime)

someFunc :: IO ()
someFunc = do
    time <- getCurrentTime
    putStrLn ("someFunc" ++ (show time))