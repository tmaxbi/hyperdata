FROM ubuntu:16.04
MAINTAINER BIQA <BIQA@tmax.co.kr>

#==================== 1) Install Package ====================
RUN cd /etc/apt 
#RUN cd /etc/apt && \
#    sed -i 's/archive.ubuntu.com/ftp.daumkakao.com/g' sources.list

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
RUN apt-get install -y net-tools
RUN apt-get install -y netcat
RUN apt-get install -y expect
RUN apt-get install -y nodejs
RUN apt-get install -y acl

RUN apt-get install -y language-pack-ko
RUN locale-gen ko_KR.UTF-8
ENV LANG ko_KR.UTF-8

RUN apt-get update -y
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y krb5-config krb5-user

RUN apt-get update -y
RUN apt-get install -y jq
RUN apt-get install -y maven

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - 
RUN apt-add-repository ppa:mosquitto-dev/mosquitto-ppa -y
RUN apt update
RUN apt-get -y install mosquitto

RUN echo "Asia/Seoul" > /etc/timezone

#==================== 2) Add Hyperdata User ====================
RUN mkdir -p /home/hyperdata
RUN useradd -d /home/hyperdata -s /bin/bash hyperdata
RUN chown -R hyperdata:hyperdata /home/hyperdata
RUN echo "hyperdata:hyperdata1234!" | chpasswd
RUN echo "root:hyperdata1234!" | chpasswd

## mosquitto setting
RUN usermod -a -G hyperdata mosquitto
RUN chown -R hyperdata:hyperdata /etc/mosquitto
RUN chown hyperdata:hyperdata /usr/sbin/mosquitto
RUN chown mosquitto:hyperdata /var/run/mosquitto

#==================== 3) Set Global ENV ====================
ENV DEPLOY_HOME=/home/hyperdata

#==================== 4) Add Java Files ====================
COPY --chown=hyperdata:hyperdata src/java $DEPLOY_HOME/java

#==================== 5) Add Jeus Files ====================
COPY --chown=hyperdata:hyperdata src/jeus $DEPLOY_HOME/jeus8

#==================== 7) Move Hadoop Env ====================
COPY --chown=hyperdata:hyperdata src/hadoop $DEPLOY_HOME/hadoop

#==================== 7-1) Set Hadoop Symbolic Link =============
RUN rm -rf /etc/krb5.conf
RUN ln -s /db/krb5_conf/krb5.conf /etc/krb5.conf

#==================== 8) Move Hyperdata Env ====================
COPY --chown=hyperdata:hyperdata src/hyperdata $DEPLOY_HOME/hyperdata20
COPY --chown=hyperdata:hyperdata src/mosquitto/mosquitto.conf /etc/mosquitto/mosquitto.conf

#==================== 9) Move Hyperdata related Files ====================
COPY --chown=hyperdata:hyperdata src/set_envs.sh $DEPLOY_HOME/set_envs.sh
COPY --chown=hyperdata:hyperdata src/init $DEPLOY_HOME/init
COPY --chown=hyperdata:hyperdata src/boot $DEPLOY_HOME/boot
COPY --chown=hyperdata:hyperdata src/init_container.sh $DEPLOY_HOME/init_container.sh
COPY --chown=hyperdata:hyperdata src/boot.sh $DEPLOY_HOME/boot.sh

USER hyperdata
WORKDIR $DEPLOY_HOME
