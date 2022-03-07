FROM ubuntu:14.04
MAINTAINER BIQA <BIQA@tmax.co.kr>

### 1) Set apt-get & Locale
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y openssh-server unzip libedit-dev libncurses-dev g++ gcc autoconf openssl \
 build-essential libicu-dev libcurl4-openssl-dev libaio-dev vim tar gdb curl software-properties-common \
 python-software-properties acl supervisor language-pack-ko lrzsz \
 && locale-gen ko_KR.UTF-8

### 2) Set SSH
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
 && sed -i 's/StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config \
 && echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config \
 && echo "ClientAliveCountMax 99999" >> /etc/ssh/sshd_config \
 && service ssh restart

### 3) Set ENV
ENV LANG=ko_KR.UTF-8 \
SRC_HOME=/src

### 4) Add Hyperdata User
RUN useradd -d /db -s /bin/bash hyperdata -m \
 && echo "hyperdata:hyperdata1234!" | chpasswd \
 && echo "root:hyperdata1234!" | chpasswd 

### 5) src Copy
COPY --chown=hyperdata:hyperdata src $SRC_HOME
COPY src/env ~/.bashrc

### 6) Set Supervisor, JDK
RUN sh $SRC_HOME/java/install.sh

### 7) Set Supervisor Env
COPY --chown=hyperdata:hyperdata $SRC_HOME/supervisord.conf /etc/supervisor/supervisord.conf
USER hyperdata
RUN chmod +x $SRC_HOME/boot.sh
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
