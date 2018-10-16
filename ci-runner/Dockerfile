FROM maven:3.5-jdk-7-alpine

# 初始化
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TERM linux
ENV TIMEZONE Asia/Taipei
ENV LC_ALL C
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

# https://github.com/yobasystems/gitlab-ci-multi-runner/blob/master/alpine-amd64/Dockerfile
RUN apk add --update \
        dumb-init \
        sudo \
		bash \
        openssh \
		ca-certificates \
		git \
		openssl \
		wget \
        vim \
		openrc \
		docker \
		py-pip 

RUN addgroup -S gitlab-runner && adduser -D -S -u 1000 gitlab-runner -G docker

RUN rc-update add docker boot

RUN pip install docker-compose

RUN wget -O /usr/bin/gitlab-ci-multi-runner https://gitlab-runner-downloads.s3.amazonaws.com/v10.0.1/binaries/gitlab-runner-linux-amd64 && \
	chmod +x /usr/bin/gitlab-ci-multi-runner && \
	ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && \
	wget -q https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
	chmod +x /usr/bin/docker-machine && \
	mkdir -p /etc/gitlab-runner/certs && \
	chmod -R 700 /etc/gitlab-runner

# gradle

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 4.5.1

ARG GRADLE_DOWNLOAD_SHA256=3e2ea0d8b96605b7c528768f646e0975bd9822f06df1f04a64fd279b1a17805e
RUN set -o errexit -o nounset \
	&& echo "Installing build dependencies" \
	&& apk add --no-cache --virtual .build-deps \
		ca-certificates \
		openssl \
		unzip \
	\
	&& echo "Downloading Gradle" \
	&& wget -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	\
	&& echo "Checking download hash" \
	&& echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
	\
	&& echo "Installing Gradle" \
	&& unzip gradle.zip \
	&& rm gradle.zip \
	&& mkdir /opt \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
	&& ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
	\
	&& apk del .build-deps \
	\
	&& mkdir /home/gitlab-runner/.gradle \
	&& chown -R gitlab-runner:gitlab-runner /home/gitlab-runner \
	\
	&& echo "Symlinking root Gradle cache to gradle Gradle cache" \
	&& ln -s /home/gitlab-runner/.gradle /root/.gradle

# Docker
ADD ./wrapdocker /usr/local/bin/wrapdocker

RUN apk --update add \
  bash \
  iptables \
  ca-certificates \
  e2fsprogs \
  docker \
  && chmod +x /usr/local/bin/wrapdocker \
  && rm -rf /var/cache/apk/*

# Entrypoint
ADD entrypoint /
RUN chmod +x /entrypoint

VOLUME ["/var/lib/docker","/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init","/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
