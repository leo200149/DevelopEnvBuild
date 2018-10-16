#!/bin/bash

PROJECT_NAME=$1
TOKEN=$2

if [[ -z "$PROJECT_NAME" ]]; then
	echo "no input project name, fail"
	exit 1
fi
if [[ -z "$TOKEN" ]]; then
	echo "no input token, fail"
	exit 1
fi

echo "register start"

docker exec -it my-runner \
    gitlab-runner register -n \
    --name $1 \
    -r $2

echo "register finish"