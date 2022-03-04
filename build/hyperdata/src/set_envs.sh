#!/bin/bash

## hadoop env
for jar in `ls $HADOOP_HOME/share/hadoop/common/*.jar | grep -v test | grep -v example`
do
    export CLASSPATH=$jar:$CLASSPATH
done
for jar in `ls $HADOOP_HOME/share/hadoop/common/lib/*.jar | grep -v test | grep -v example`
do
    export CLASSPATH=$jar:$CLASSPATH
done
for jar in `ls $HADOOP_HOME/share/hadoop/hdfs/*.jar | grep -v test | grep -v example`
do
    export CLASSPATH=$jar:$CLASSPATH
done
for jar in `ls $HADOOP_HOME/share/hadoop/hdfs/lib/*.jar | grep -v test | grep -v example`
do
    export CLASSPATH=$jar:$CLASSPATH
done
for jar in `ls $HADOOP_HOME/share/hadoop/yarn/*.jar | grep -v test | grep -v example`
do
    export CLASSPATH=$jar:$CLASSPATH
done
for jar in `ls $HADOOP_HOME/share/hadoop/mapreduce/*.jar | grep -v test | grep -v example`
do
    export CLASSPATH=$jar:$CLASSPATH
done

## Alias
alias hdboot='startDomainAdminServer -u jeus -p jeus;startManagedServer -server hyperdata -u jeus -p jeus;startManagedServer -server ProAuth -u jeus -p jeus;'
alias polog='tail -f $PROOBEJCT_HOME/logs/ProObject.log'
alias tlog='tail -f $TB_HOME/instance/tibero/log/slog/sys.log'
alias jeuswebon='jeusadmin -u jeus -p jeus "enable-webadmin"'
alias jeusweboff='jeusadmin -u jeus -p jeus "disable-webadmin"'
