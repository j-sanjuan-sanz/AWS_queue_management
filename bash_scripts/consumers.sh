#!/bin/bash

get_queue_url (){
	queue_url=$(aws sqs get-queue-url --queue-name $queue_name --output text)
}


receive_message (){
	receiptHandle=$(aws sqs receive-message --queue-url $queue_url)

	receiptHandle=${receiptHandle#*ReceiptHandle}
	receiptHandle=${receiptHandle%MD5OfBody*}
	nchar=${#receiptHandle}
	receiptHandle=${receiptHandle:4:nchar-20}
}


delete_message(){
	aws sqs delete-message --queue-url $queue_url --receipt-handle $receiptHandle

}

queue_name="proyect_queue.fifo"
queue_url=""
receiptHandle=""

get_queue_url

receive_message

delete_message

