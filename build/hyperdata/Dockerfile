FROM ubuntu:16.04
MAINTAINER BIQA <BIQA@tmax.co.kr>

#==================== 1) Set Package & Locale ====================
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y software-properties-common python-software-properties language-pack-ko

RUN apt-add-repository universe \
 && apt-add-repository ppa:mosquitto-dev/mosquitto-ppa -y

RUN locale-gen ko_KR.UTF-8

ENV LANG=ko_KR.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - 
RUN echo "Asia/Seoul" > /etc/timezone

#==================== 2) Install Package ====================
RUN apt-get install -y openssh-server unzip moreutils libedit-dev libncurses-dev g++ gcc autoconf openssl build-essential \
 libicu-dev libcurl4-openssl-dev libaio-dev vim tar gdb curl supervisor \
 apt-transport-https net-tools netcat expect nodejs acl jq maven krb5-config krb5-user mosquitto

#==================== 3) Set SSH ====================
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
 && sed -i 's/StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config \
 && echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config \
 && echo "ClientAliveCountMax 99999" >> /etc/ssh/sshd_config \
 && service ssh restart

#==================== 4) Set Global Env ====================
ENV DEPLOY_HOME=/home/hyperdata

#==================== 5) Add Hyperdata User ====================
RUN mkdir -p /home/hyperdata \
 && useradd -d /home/hyperdata -s /bin/bash hyperdata \
 && chown -R hyperdata:hyperdata /home/hyperdata \
 && echo "hyperdata:hyperdata1234!" | chpasswd \
 && echo "root:hyperdata1234!" | chpasswd

## mosquitto setting
RUN usermod -a -G hyperdata mosquitto \
 && chown -R hyperdata:hyperdata /etc/mosquitto \
 && chown hyperdata:hyperdata /usr/sbin/mosquitto \
 && chown mosquitto:hyperdata /var/run/mosquitto

#==================== 5) Change Owner ====================
COPY --chown=hyperdata:hyperdata src/java $DEPLOY_HOME/java \
  && --chown=hyperdata:hyperdata src/jeus $DEPLOY_HOME/jeus8 \
  && --chown=hyperdata:hyperdata src/hadoop $DEPLOY_HOME/hadoop \
  && --chown=hyperdata:hyperdata src/hyperdata $DEPLOY_HOME/hyperdata20 \
  && --chown=hyperdata:hyperdata src/mosquitto/mosquitto.conf /etc/mosquitto/mosquitto.conf \
  && --chown=hyperdata:hyperdata src/set_envs.sh $DEPLOY_HOME/set_envs.sh \
  && --chown=hyperdata:hyperdata src/init $DEPLOY_HOME/init \
  && --chown=hyperdata:hyperdata src/boot $DEPLOY_HOME/boot \
  && --chown=hyperdata:hyperdata src/init_container.sh $DEPLOY_HOME/init_container.sh \
  &&--chown=hyperdata:hyperdata src/boot.sh $DEPLOY_HOME/boot.sh
  
#==================== 6) Set Hadoop Symbolic Link =============
RUN rm -rf /etc/krb5.conf
RUN ln -s /db/krb5_conf/krb5.conf /etc/krb5.conf
