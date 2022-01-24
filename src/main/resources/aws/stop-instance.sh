#!/bin/bash

#declaring variables
instanceName=$AWS_ENV'-instance'
intanceValues=()
instanceStateCode=""
instanceStateName=""
instanceId=""
publicIpAddress=""

isReserved(){

	#checking if the resource already exists
	rs=$(aws ec2 describe-instances --profile $AWS_PROFILE --query 'length(Reservations[].Instances[].[Tags[?Key==`Name`].Value][][?@==`'$instanceName'`][])')
	if [ $rs != 0 ]; then
		echo "######################### The resource already exists. #########################"
		return 0
	else
		echo "######################### The resource doesnt exist. #########################"
		return 1
	fi
}

getInstanceInfo(){
	
	intanceValues=($(aws ec2 describe-instances \
	--profile $AWS_PROFILE \
	--query 'Reservations[*].Instances[*].{instanceStateCode: State.Code, instanceStateName: State.Name, publicIpAddress: PublicIpAddress, instanceId: InstanceId, instanceName: Tags[?Key==`Name`].Value}[?instanceName[0]==`'$instanceName'`][][instanceId, instanceStateCode, instanceStateName]' \
	--output text | 
	tr -s '[:space:]' "\n"))
	
	instanceStateCode=${intanceValues[1]}
	instanceStateName=${intanceValues[2]}
	instanceId=${intanceValues[0]}
	
}
isInstanceRuning(){
	echo "######################### Instance State Name: $instanceStateName  #########################";
	echo "######################### Instance State Code: $instanceStateCode  #########################";
	#if status code is equal to 16 then this instance is running 
	if [ $instanceStateCode == 16 ] 
	then
		return 0
	else
		return 1
	fi 
}

stopInstance(){
	aws ec2 stop-instances --instance-ids $instanceId
}

main(){

	#checking if the resource already exists
	isReserved
	if [ $? == 0 ]; then
		echo "######################### Getting instance information #########################"
		getInstanceInfo
		if [ $? == 0 ]; then
			echo "######################### Is Instance running. #########################"
			isInstanceRuning
			if [ $? == 0 ] 
			then
				echo "######################### Stop Instance. #########################"
				stopInstance
			else
				echo "######################### The Instance is already stoped. #########################"
			fi
		fi
	fi
}

#calling main function
main
