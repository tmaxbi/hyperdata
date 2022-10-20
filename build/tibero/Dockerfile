FROM ubuntu:14.04
MAINTAINER BIQA <BIQA@tmax.co.kr>

#==================== 1) Install Package ====================
RUN mkdir -p /db
RUN mkdir -p /deploy_src/src
WORKDIR /deploy_src

RUN cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/ftp.daumkakao.com/g' sources.list

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y openssh-server
RUN apt-get install unzip

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
RUN apt-get install -y acl

RUN add-apt-repository universe
RUN apt-get install -y supervisor
RUN apt-get install -y language-pack-ko
RUN locale-gen ko_KR.UTF-8

### install in root ###

#RUN mv /bin/sh /bin/sh.bak
#RUN ln -s bash /bin/sh
RUN mkdir -p /db/client

COPY src.tar.gz /deploy_src/src.tar.gz
RUN tar -xvf /deploy_src/src.tar.gz

RUN sh /deploy_src/src/java/install.sh

RUN mkdir -p /etc/supervisor/conf.d

RUN useradd -d /db -s /bin/bash hyperdata
RUN echo "hyperdata:hyperdata1234!" | chpasswd
RUN echo "root:hyperdata1234!" | chpasswd

RUN chown -R hyperdata:hyperdata /db
RUN chown -R hyperdata:hyperdata /deploy_src

#==================== 2) Set ENV ====================
ENV LANG ko_KR.UTF-8
ENV JAVA_HOME /usr/local/jdk1.8.0_172
ENV PATH $JAVA_HOME/bin:$PATH
ENV CLASSPATH .:$JAVA_HOME/jre/lib/ext:$JAVA_HOME/lib/tools.jar
ENV CATALINA_OPTS Djava.awt.headless=true

ENV CLI_HOME=/db/client
ENV TB_HOME=/db/tibero6
ENV TB_SID=tibero 
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:$TB_HOME/lib:$TB_HOME/client/lib:$JAVA_HOME/jre/lib/amd64/server:$CLI_HOME/oracle_lib
ENV PATH=$PATH:$TB_HOME/bin:$TB_HOME/client/bin

ENV HADOOP_HOME=/db/hadoop-2.9.2
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME                                                                                                             
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_OPTS="${HADOOP_OPTS} -Djava.library.path=$HADOOP_COMMON_LIB_NATIVE_DIR"
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH


#==================== 3) Set Tibero ENV ====================

#COPY --chown=hyperdata:hyperdata src.tar.gz /deploy_src/src.tar.gz
#RUN tar -xvf /deploy_src/src.tar.gz

#==================== 4) make $TB_VOLUME/logo  ==================
RUN mkdir -p /db/logo
RUN mkdir -p /db/guide

#==================== 5) Set Supervisor ENV ====================

#RUN mkdir -p /etc/supervisor/conf.d
COPY --chown=hyperdata:hyperdata /src/supervisord.conf /etc/supervisor/supervisord.conf
USER hyperdata
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
