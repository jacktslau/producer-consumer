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
* [[0.5.0](https://github.com/jtaisa/producer-consumer/tree/v0.5.0)] using Apache Kafka as Queue, data stored in MongoDB, Producers and Consumers are separated into two services. 

Please refer to the [CHANGELOG](./CHANGELOG) for details and issues

### Prerequisite
Please install the following tools in order to build/develop this project

* [Ruby](https://www.ruby-lang.org)
* [Docker](https://docs.docker.com/install/)


### Start Local Servers

1. Build gem for producer-consumer common lib 
   
   `$ cd common ; gem build pc-common.gemspec ; gem install pc-common-0.0.1.gem`

2. Start MongoDB and Apache Kafka 

   `$ docker-compose up -d`

3. Start Consumer 

   `$ cd consumer ; sh start.sh`

4. Start Producer 

   `$ cd producer ; sh start.sh`

### Run in Docker image

`$ docker-compose -f docker-compose-app.yml up -d`
