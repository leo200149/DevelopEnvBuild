#!/bin/bash
IMAGE=mydomain/gitlab-ci-runner-maven
VERSION=alpine

echo "${IMAGE}:${VERSION}"
docker rmi -f ${IMAGE}:${VERSION}
docker build -t ${IMAGE}:${VERSION} .
docker tag ${IMAGE}:${VERSION} ${IMAGE}:latest