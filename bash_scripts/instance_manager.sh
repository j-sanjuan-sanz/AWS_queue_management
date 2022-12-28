#!/bin/bash
export EC2_REGION=us-east-1b



get_queue_url (){
	queue_url=$(aws sqs get-queue-url --queue-name $queue_name --output text)
}

update_message_number(){

	queue_messages=$(aws sqs get-queue-attributes --queue-url $queue_url --attribute-names ApproximateNumberOfMessages --output text)
	queue_messages=($(echo $queue_messages | tr ' ' "\n"))

	message_number=${queue_messages[1]}
}


update_instances_active(){

	instances_active=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text)
	instances_active=($(echo $instances_active | tr ' ' "\n"))
}


update_instances_status(){
	
	message_factor=$(((($message_number + 9)/10)))
	instances_status=$(($message_factor - $instances_number)) 
}


create_instance() {

	name_instance="copy_"$instances_number
	image_id=$(aws ec2 create-image --instance-id $original_instance_id --name $name_instance --query ImageId --output text)
	aws ec2 run-instances --image-id $image_id --instance-type t2.micro
}


delete_last_instance() {
	
	instance_to_erase=${instances_active[(instances_number-1)]}
	#aws ec2 delete-instance --instance-id $instance_to_erase
	aws ec2 terminate-instances --instance-ids $instance_to_erase
}


original_instance_id="i-0064e94b52167acba"
queue_name="proyect_queue.fifo"

queue_url=""
message_number=0
instances_active=""
message_factor=0
instances_status=0

if get_queue_url; then
	# queue exist
	update_message_number
else
	# queue doesn't exist
	# echo "Queue doesn't exist"
	message_number=0
fi

update_instances_active

instances_number=${#instances_active[@]}

update_instances_status


if [[ "$instances_status" -lt 0 ]] && [[ "$instances_number" -gt 1 ]]; then
	# echo "delete"
	delete_last_instance
fi

if [[ "$instances_status" -gt 0 ]] && [[ "$instances_number" -lt 5 ]]; then
	# echo "create"
	create_instance
fi







