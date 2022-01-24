#!/bin/bash

#declaring variables
instanceName=$AWS_ENV'-instance'
ipAddress=""
userName=ubuntu
dirName=app-files
zipFile=$dirName.zip

transferCommpressedFile(){
	scp -i $(private_key.secureFilePath) $zipFile $userName@$ipAddress:~/deployment/
}
getIpAddress(){
	
	intanceValues=($(aws ec2 describe-instances \
	--profile $AWS_PROFILE \
	--query 'Reservations[*].Instances[*].{instanceStateCode: State.Code, instanceStateName: State.Name, publicIpAddress: PublicIpAddress, instanceId: InstanceId, instanceName: Tags[?Key==`Name`].Value}[?instanceName[0]==`'$instanceName'`][][publicIpAddress]' \
	--output text | 
	tr -s '[:space:]' "\n"))
	
	ipAddress=${intanceValues[0]}
	
	echo "######################### Ip address $ipAddress #########################"
	
}

main(){

	echo "######################### Getting ip address #########################"
	getIpAddress
	echo "######################### Transfering zip file #########################"
	transferCommpressedFile
}

#calling main function
main
