## Introduction
This is a producer and consumer sample implemented in ruby. 
It simulates bank transaction updating account balance in producers and consumers.

### Producer
Each producer randomly produces a PAYMENT / TOPUP transaction and pushed into a queue.
Then it will update account balance and saved into the account logs.

### Consumer
Each consumer reads the transaction from the queue and log it. 

### WebServer

`/toggle`

Start or stop the producers and consumers. 
It returns all accounts and transaction in json format when it stops.

`/consumer/log`

Open a consumer UI to display any transaction log once it received.

## Run
`> bundle exec thin -R config.ru -p 9000 -e development start`
