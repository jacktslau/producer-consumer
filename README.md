## Introduction
This is a producer and consumer implemented in ruby web application.

## Implementation

### Producer
Each producer randomly produce a transaction object and pushed into a queue

### Consumer
Each consumer reads the object from the queue and writes into log 


### WebServer

### API
`GET /toggle`

Start or stop the producers and consumers.

`GET /consume`

Read the consumer's log 

## Run
`> rackup config.ru`
