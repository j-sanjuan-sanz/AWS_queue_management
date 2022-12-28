#!/bin/bash

get_queue_url (){
	queue_url=$(aws sqs get-queue-url --queue-name $queue_name  --output text)
}


create_queue (){
	aws sqs create-queue --queue-name $queue_name --attributes "{\"FifoQueue\":\"true\", \"ContentBasedDeduplication\":\"true\"}"

}

purge_queue(){
	aws sqs purge-queue --queue-url $queue_url
}


send_messages(){
	
	for i in $(seq 0 1 99) ; do
		message_body="TEST MESSAGE $i"
		aws sqs send-message --queue-url $queue_url --message-body "$message_body" --message-group-id "messaging_system" 2>&1 > /dev/null

	done
}

queue_name="proyect_queue.fifo"
queue_url=""


if get_queue_url; then
	# queue exist
	purge_queue
else
	# queue doesn't exist
	create_queue
	get_queue_url
fi

send_messages




