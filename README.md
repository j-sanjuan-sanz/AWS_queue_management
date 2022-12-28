# AWS_queue_management
## Linux Bash scripts managing instances in AWS

This proyect focus on AWS instance management. 

- The AWS queue `proyect_queue.fifo` contains user petitions.
- `producers.sh` search if queue does exist. Then, purge it if exists, create it if don't. Lastly, it sends messages to fill the queue.
- `consumers.sh` receive messages from the queue. In a production state, this would initiate the message processing. These messages are only test messages so the consumer removes the message, symbolyzing the message has been processed.
- `instance_manager.sh` checks instances status, and create or destroy instances depending on current demand. It allways let one instance active.
-  `parallel.sh` call `producers.sh` so queue is initialized and full of messages. Then run in parallel `consumers.sh` with some waiting time, so messages will be removed slowly. Meanwhile, `instance_manager.sh` will change the number of active instances, increasing then first, until queue is emptier, so it starts deleting instances. 




