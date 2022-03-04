FROM ubuntu:16.04
MAINTAINER BIQA <BIQA@tmax.co.kr>

### 1) Set apt-get & Locale
ENV DEBCONF_NOWARNINGS=yes

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y software-properties-common python-software-properties language-pack-ko curl

RUN apt-add-repository universe \
 && apt-add-repository ppa:mosquitto-dev/mosquitto-ppa -y \
 && apt-get update

RUN locale-gen ko_KR.UTF-8 \
 && echo "Asia/Seoul" > /etc/timezone

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
 
### 5) mosquitto setting
RUN usermod -a -G hyperdata mosquitto \
 && chown -R hyperdata:hyperdata /etc/mosquitto \
 && chown hyperdata:hyperdata /usr/sbin/mosquitto \
 && chown mosquitto:hyperdata /var/run/mosquitto

### 6) Set ENV
ENV LANG=ko_KR.UTF-8 \
JAVA_HOME=/usr/local/jdk1.8.0_172 \
PATH=$JAVA_HOME/bin:$PATH \
CLASSPATH=.:$JAVA_HOME/jre/lib/ext:$JAVA_HOME/lib/tools.jar \
CATALINA_OPTS=Djava.awt.headless=true \
TB_HOME=$TB_MOUNT_VOLUME_PATH/tibero6 \
TB_SID=tibero \
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:$TB_HOME/lib:$TB_HOME/client/lib:$JAVA_HOME/jre/lib/amd64/server \
PATH=$PATH:$TB_HOME/bin:$TB_HOME/client/bin \
HADOOP_HOME=$TB_MOUNT_VOLUME_PATH/hadoop-2.9.2 \
HADOOP_MAPRED_HOME=$HADOOP_HOME \
HADOOP_HDFS_HOME=$HADOOP_HOME \
HADOOP_YARN_HOME=$HADOOP_HOME \ 
HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native \
HADOOP_OPTS="${HADOOP_OPTS} -Djava.library.path=$HADOOP_COMMON_LIB_NATIVE_DIR" \
PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin \
LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH \
SRC_HOME=/src

### 7) src copy
COPY --chown=hyperdata:hyperdata src $SRC_HOME
USER hyperdata
RUN mv $SRC_HOME/jeus $HOME/jeus8 \
 && mv $SRC_HOME/hyperdata $HOME/hyperdata20 \
 && mv $SRC_HOME/mosquitto/mosquitto.conf /etc/mosquitto/mosquitto.conf
 
### 8) Set Symbolic Link
USER root
RUN rm -rf /etc/krb5.conf \
 && ln -s $SRC_HOME/krb5_conf/krb5.conf /etc/krb5.conf

### 9) Login User
USER hyperdata
