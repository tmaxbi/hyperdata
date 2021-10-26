#!/bin/bash

tar -zxf /deploy_src/src/client/hadoop_cli/hadoop-2.9.2.tar.gz -C /db
cp /deploy_src/src/hadoop/hadoop_classpath2.conf ~/.bashrc
source ~/.bashrc

