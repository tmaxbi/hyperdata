FROM ubuntu:16.04
MAINTAINER BIQA <BIQA@tmax.co.kr>

#==================== 1) Install Package ====================
RUN cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/ftp.daumkakao.com/g' sources.list

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y openssh-server
RUN apt-get install -y unzip
RUN apt-get install -y moreutils

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config
RUN echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
RUN echo "ClientAliveCountMax 99999" >> /etc/ssh/sshd_config

RUN service ssh restart

RUN apt-get install -y libedit-dev libncurses-dev g++ gcc autoconf openssl
RUN apt-get install -y build-essential libicu-dev libcurl4-openssl-dev
RUN apt-get install -y libaio-dev vim tar
RUN apt-get install -y gdb curl

RUN apt-get install -y software-properties-common
RUN apt-get install -y python-software-properties

RUN add-apt-repository universe
RUN apt-get install -y supervisor
RUN apt-get install -y apt-transport-https
RUN apt-get install -y  net-tools
RUN apt-get install -y  expect

RUN apt-get install -y language-pack-ko
RUN locale-gen ko_KR.UTF-8
ENV LANG ko_KR.UTF-8

RUN apt-get update -y
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y krb5-config krb5-user

RUN apt-get update -y
RUN apt-get install -y jq

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - 
RUN echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list 
RUN apt-add-repository ppa:mosquitto-dev/mosquitto-ppa -y
RUN apt update
RUN apt-get -qy install kubectl=1.5.3-00
RUN apt-get -y install mosquitto

RUN echo "listener 1883" >> /etc/mosquitto/mosquitto.conf
RUN echo "allow_anonymous true" >> /etc/mosquitto/mosquitto.conf

RUN echo "listener 2883" >> /etc/mosquitto/mosquitto.conf
RUN echo "allow_anonymous true" >> /etc/mosquitto/mosquitto.conf
RUN echo "protocol websockets" >> /etc/mosquitto/mosquitto.conf

RUN service mosquitto restart

RUN echo "Asia/Seoul" > /etc/timezone

#==================== 2) Set Global ENV ====================
ENV DEPLOY_HOME=/deploy_src

#==================== 3) Add Java Files ====================
COPY src/java $DEPLOY_HOME/java

#==================== 4) Add Jeus Files ====================
COPY src/jeus $DEPLOY_HOME/jeus8

#==================== 5) Move Hadoop Env ====================
COPY src/hadoop $DEPLOY_HOME/hadoop

#==================== 6) Move Hyperdata Env ====================
COPY src/hyperdata $DEPLOY_HOME/hyperdata8.3

#==================== 7) Move Hyperdata related Files ====================
COPY src/set_envs.sh /root/set_envs.sh
COPY src/boot.sh /root/boot.sh
COPY src/init_container.sh /root/init_container.sh

WORKDIR /root

