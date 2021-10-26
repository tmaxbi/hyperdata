#!/bin/bash
TMP_BACKEND_IP=`ifconfig|awk '{print $2}'|sed -n '2p'|awk -F ':' '{print $2}'`
TMP_HOST_IP=`sed -n '2p' $TB_HOME/client/config/tbdsn.tbr|grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
echo "TMP_BACKEND_IP IS "$TMP_BACKEND_IP
echo "TMP_HOST_IP IS "$TMP_HOST_IP

if [ $TMP_BACKEND_IP != $TMP_HOST_IP ];then
sed -i "s/HOST=${TMP_HOST_IP}/HOST=${TMP_BACKEND_IP}/g" ${TB_HOME}/client/config/tbdsn.tbr
fi

cat ${TB_HOME}/client/config/tbdsn.tbr
