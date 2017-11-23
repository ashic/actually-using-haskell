# Actually Using Haskell

A Haskell example that provides an API with Scotty, talks to Cassandra with cql-io, and Kafka with hw-kafka-client.

You need Haskell Stack installed to play with this. 

From the root folder run

```
docker-compose up
```

Go into src/auh and run

```
stack setup
stack build
stack exec auh-exe
```

Slides are available at [https://ashic.github.io/actually-using-haskell/#/](https://ashic.github.io/actually-using-haskell/#/)
