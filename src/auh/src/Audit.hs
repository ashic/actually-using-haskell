module Audit where

import Data.Monoid ((<>))
import qualified Data.ByteString.Char8 as B
import Control.Monad (forM_)
import Control.Monad.IO.Class
import Kafka.Producer

producerProps :: ProducerProperties
producerProps = brokersList [BrokerAddress "127.0.0.1:9092"]
             <> logLevel KafkaLogDebug

targetTopic :: TopicName
targetTopic = TopicName "audit"

-- ./kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic test2
-- https://hackage.haskell.org/package/hw-kafka-client-2.1.0/docs/Kafka-Producer.html

initAudit :: MonadIO m => m (Either KafkaError KafkaProducer)
initAudit = newProducer producerProps

closeAudit :: MonadIO m => KafkaProducer -> m ()
closeAudit = closeProducer

record key msg kafka =
    produceMessage kafka record 
    where 
        record = ProducerRecord
                  { prTopic = targetTopic
                  , prPartition = UnassignedPartition
                  , prKey = Just $ B.pack key
                  , prValue = Just $ B.pack msg
                  }
