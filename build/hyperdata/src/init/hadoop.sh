#!/bin/bash
set -e

. $HOME/set_envs.sh
mkdir -p $TB_VOLUME/krb5_conf
cp $HOME/hadoop/krb5.conf $TB_VOLUME/krb5_conf
