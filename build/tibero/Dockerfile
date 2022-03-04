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

### 3) Add Hyperdata User
RUN useradd -d /db -s /bin/bash hyperdata -m \
 && echo "hyperdata:hyperdata1234!" | chpasswd \
 && echo "root:hyperdata1234!" | chpasswd 

### 4) Set ENV
ENV LANG=ko_KR.UTF-8 \
JAVA_HOME=/usr/local/jdk1.8.0_172 \
PATH=$JAVA_HOME/bin:$PATH \
CLASSPATH=.:$JAVA_HOME/jre/lib/ext:$JAVA_HOME/lib/tools.jar \
CATALINA_OPTS=Djava.awt.headless=true \
CLI_HOME=/db/client \
TB_HOME=/db/tibero6 \
TB_SID=tibero \
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:$TB_HOME/lib:$TB_HOME/client/lib:$JAVA_HOME/jre/lib/amd64/server:$CLI_HOME/oracle_lib \
PATH=$PATH:$TB_HOME/bin:$TB_HOME/client/bin \
HADOOP_HOME=/db/hadoop-2.9.2 \
HADOOP_MAPRED_HOME=$HADOOP_HOME \
HADOOP_HDFS_HOME=$HADOOP_HOME \
HADOOP_YARN_HOME=$HADOOP_HOME \ 
HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native \
HADOOP_OPTS="${HADOOP_OPTS} -Djava.library.path=$HADOOP_COMMON_LIB_NATIVE_DIR" \
PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin \
LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH

### 5) src Copy
COPY --chown=hyperdata:hyperdata src.tar.gz /db/src.tar.gz
USER hyperdata
RUN tar -xf /db/src.tar.gz -C /db \
 && rm -rf /db/src.tar.gz

### 6) Set Supervisor, JDK
USER root
RUN sh /db/src/java/install.sh

### 8) Set Supervisor Env
COPY --chown=hyperdata:hyperdata /src/supervisord.conf /etc/supervisor/supervisord.conf
USER hyperdata
RUN chmod +x /db/src/boot.sh
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
