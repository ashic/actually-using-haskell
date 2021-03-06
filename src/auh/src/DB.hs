module DB where

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

cqlQuery queryString p client  = 
    runClient client $ query queryString $ cqlParams p


cqlQuery1 queryString p client  = 
    runClient client $ query1 queryString $ cqlParams p
    

cqlWrite1 queryString p client = 
    runClient client $ write queryString $ cqlParams p

    