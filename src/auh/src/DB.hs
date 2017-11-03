{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module DB where

import Control.Monad.IO.Class
import Control.Monad
import Data.String
import Data.Text

import qualified System.Logger as Logger
import Database.CQL.IO as Client
import Database.CQL.Protocol


connect:: IO ClientState
connect = do
    g <- Logger.new Logger.defSettings
    c <- Client.init g defSettings
    return c

cqlParams :: Tuple a => a -> QueryParams a
cqlParams p = QueryParams One False p Nothing Nothing Nothing

cqlQuery queryString params client  = 
    runClient client $ query queryString $ cqlParams params
    


        