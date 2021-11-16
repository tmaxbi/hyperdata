#!/bin/bash
set -e

. $DEPLOY_HOME/set_envs.sh

mkdir -p $TB_VOLUME/krb5_conf

cp $DEPLOY_HOME/hadoop/krb5.conf $TB_VOLUME/krb5_conf;

#rm -rf /etc/krb5.conf
#ln -s /db/krb5_conf/krb5.conf /etc/krb5.conf;
