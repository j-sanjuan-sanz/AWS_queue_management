#!/bin/bash


call_producers () {
	sudo ./producers.sh
}

call_consumers () {
	sleep 6
	sudo ./producers.sh
}

call_instance_manager () {
	sleep 15
	sudo ./instance_manager.sh 
}



call_producers & 
for i in $(seq 0 1 99); do call_consumers; done &
for i in $(seq 0 1 39); do call_instance_manager; done


