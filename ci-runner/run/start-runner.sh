#!/bin/bash
PWD=$(pwd)

docker run -d --name my-runner \
--privileged=true \
--ulimit nofile=60000 \
--shm-size=1024m \
--restart=always \
--add-host "mydomain.dev.com:192.168.1.111" \
--add-host "mydomain.dev.gitlab.com:192.168.1.111" \
--add-host "mydomain.dev.nexus.com:192.168.1.111" \
-e CI_SERVER_URL=http://mydomain.dev.gitlab.com/ \
-e RUNNER_DESCRIPTION=my-runner \
-e RUNNER_EXECUTOR=shell \
-v $PWD/volumes/certs:/etc/gitlab-runner/certs \
-v $PWD/volumes/config:/etc/gitlab-runner \
-v $PWD/volumes/ssh:/home/gitlab-runner/.ssh \
-v $PWD/volumes/m2:/home/gitlab-runner/.m2 \
-v $PWD/volumes/scripts:/home/gitlab-runner/scripts \
-v $PWD/volumes/docker/daemon.json:/etc/docker/daemon.json \
mydomain/gitlab-ci-runner-maven:alpine