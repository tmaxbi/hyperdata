#!/bin/bash
set -e

mkdir -p $TB_VOLUME/krb5_conf
cp $SRC_HOME/hadoop/krb5.conf $TB_VOLUME/krb5_conf
