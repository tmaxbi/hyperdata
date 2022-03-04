#!/bin/bash
set -e

mkdir -p $TB_VOLUME/krb5_conf
cp $HOME/hadoop/krb5.conf $TB_VOLUME/krb5_conf
