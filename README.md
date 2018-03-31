## Introduction
This is a producer and consumer sample implemented in ruby. 
It simulates bank transaction updating account balance in producers and consumers.

### Producer
Each producer randomly produces a PAYMENT / TOPUP transaction and pushed into a queue.
Then it will update account balance and saved into the account logs.

### Consumer
Each consumer reads the transaction from the queue and log it. 

### WebServer

`http://localhost:9292/toggle`

Start or stop the producers and consumers. 
It returns all accounts and transaction in json format when it stops.

`http://localhost:9292/consumer/log`

Open a consumer UI to display any transaction log once it received.

## Implementation

Here is the different implementation in each version:
* [[0.3.0](https://github.com/jtaisa/producer-consumer/tree/v0.3.0)] using Ruby build-in Queue, data stored in ram, Producers and Consumers all implemented in a single Sinatra web service.
* [[0.4.0](https://github.com/jtaisa/producer-consumer/tree/v0.4.0)] using Ruby build-in Queue, data stored in MongoDB, Producers and Consumers all implemented in a single Sinatra web service.
* [[0.5.0](https://github.com/jtaisa/producer-consumer/tree/v0.5.0)] using Apache Kafka as Queue, data stored in MongoDB, Producers and Consumers are separated into two servers. 

Please refer to the [CHANGELOG](./CHANGELOG) for details

### Prerequisite
Please install the following tools in order to build/develop this project

* [Ruby](https://www.ruby-lang.org)
* [Docker](https://docs.docker.com/install/)


### Start Local Server
`$ sh start.sh`

### Run in Docker image

`$ docker build -t producer-consumer .`

`$ docker run -d -p 9292:9292 producer-consumer`