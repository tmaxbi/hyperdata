FROM ubuntu:16.04
MAINTAINER BIQA <BIQA@tmax.co.kr>

### 1) Set apt-get & Locale
ENV DEBCONF_NOWARNINGS=yes \
SRC_HOME=/src

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y software-properties-common python-software-properties language-pack-ko curl

RUN apt-add-repository universe \
 && apt-add-repository ppa:mosquitto-dev/mosquitto-ppa -y \
 && apt-get update

RUN locale-gen ko_KR.UTF-8
ENV LANG=ko_KR.UTF-8

RUN echo "Asia/Seoul" > /etc/timezone

### 2) Install Package 
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - 

RUN apt-get install -y openssh-server unzip moreutils libedit-dev libncurses-dev g++ gcc autoconf openssl build-essential \
 libicu-dev libcurl4-openssl-dev libaio-dev vim tar gdb supervisor \
 apt-transport-https net-tools netcat expect nodejs acl jq maven mosquitto lrzsz

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y krb5-config krb5-user

### 3) Set SSH 
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
 && sed -i 's/StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config \
 && echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config \
 && echo "ClientAliveCountMax 99999" >> /etc/ssh/sshd_config \
 && service ssh restart

### 4) Add Hyperdata User
RUN useradd -d /home/hyperdata -s /bin/bash hyperdata -m \
 && echo "hyperdata:hyperdata1234!" | chpasswd \
 && echo "root:hyperdata1234!" | chpasswd
 
## 5) mosquitto setting
RUN usermod -a -G hyperdata mosquitto \
 && chown -R hyperdata:hyperdata /etc/mosquitto \
 && chown hyperdata:hyperdata /usr/sbin/mosquitto \
 && chown mosquitto:hyperdata /var/run/mosquitto

### 6) src copy
COPY --chown=hyperdata:hyperdata src $SRC_HOME
USER hyperdata
RUN mv /db/hd/jeus $HOME/jeus8 \
 && mv /db/hd/hyperdata $HOME/hyperdata20 \
 && mv /db/hd/mosquitto/mosquitto.conf /etc/mosquitto/mosquitto.conf
 
### 8) Set Symbolic Link
USER root
RUN rm -rf /etc/krb5.conf \
 && ln -s /db/hd/krb5_conf/krb5.conf /etc/krb5.conf

### 10) Login User
USER hyperdata
