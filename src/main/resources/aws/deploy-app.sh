#!/bin/bash

#declaring variables
imageName=config-server-img
containerName=config-server-ctr
portNumber=8888
hostPath=/home/ubuntu/config-files
containerPath=/home/config_usr/application/config-files
jarFileName=config-server-0.0.1-SNAPSHOT.jar

removeContainer(){
	docker rm --force $containerName
}

createImage(){
	docker build -t $imageName .
}

runContainer(){
docker run \
	-d \
	-e SPRING_SECURITY_USER_NAME="$SPRING_SECURITY_USER_NAME" \
	-e SPRING_SECURITY_USER_PASSWORD="$SPRING_SECURITY_USER_PASSWORD" \
	-e SPRING_CLOUD_CONFIG_SERVER_NATIVE_SEARCHLOCATIONS="file:"$containerPath"/{label}" \
	--name $containerName \
	-p $portNumber:$portNumber -v $hostPath:$containerPath $imageName
}

main(){

	echo "######################### Removing container #########################"
	removeContainer
	echo "######################### Creating Image #########################"
	createImage
	echo "######################### Runing Container #########################"
	runContainer
}

#calling main function
main
