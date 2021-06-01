#!/bin/bash

# set environment variables
## root env
export ROOT_HOME=$DEPLOY_HOME

## java env
export JAVA_HOME=$ROOT_HOME/java
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=$JAVA_HOME/jre/lib:$JAVA_HOME/jre/lib/ext:$JAVA_HOME/lib/tools.jar
export CATALINA_OPTS=Djava.awt.headless=true

## tibero env
export TB_VOLUME=$TB_MOUNT_VOLUME_PATH
export TB_HOME=$TB_VOLUME/tibero6
export TB_SID=tibero
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:$TB_HOME/lib:$TB_HOME/client/lib:$JAVA_HOME/jre/lib/amd64/server
export PATH=$PATH:$TB_HOME/bin:$TB_HOME/client/bin

## jeus env
export JEUS_HOME=$ROOT_HOME/jeus8
export ANT_HOME=$JEUS_HOME/lib/etc/ant
export PATH=$PATH:$ANT_HOME/bin:$JEUS_HOME/bin

## proobject env
export PROOBJECT_HOME=$ROOT_HOME/proobject7

## hadoop env
export HADOOP_VOLUME=$TB_MOUNT_VOLUME_PATH
export HADOOP_HOME=$HADOOP_VOLUME/hadoop-2.9.2
export HADOOP_MAPRED_HOME=$HADOOP_HOME                                                                                                             
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="${HADOOP_OPTS} -Djava.library.path=$HADOOP_COMMON_LIB_NATIVE_DIR"
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH

## hyperdata env
export HD_HOME=$ROOT_HOME/hyperdata8.3
export SCHEMA_VERSION_FILE=$HD_HOME/HD_SCHEMA_VERSION
export HD_VERSION=8
export HD_SCHEMA_VERSION=8.3.4hotpatch
