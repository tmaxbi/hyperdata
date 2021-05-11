#!/bin/bash

## TODO: install_interactive.sh를 매번 돌리지 않아도 정상적으로 수행되도록 수정

# set envs
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
. $parent_path/set_envs.sh

## create jeus binary
chmod -R 755 $JEUS_HOME/lib/etc/ant/bin
cd $JEUS_HOME/setup
ant install

## run hyperdata
export SKIP_RECREATE_SCHEMA="Y"
export SKIP_RECREATE_ROLE_AND_PERMISSION="Y"
export SKIP_RECREATE_ADMIN="Y"
bash $HD_HOME/scripts/install_interactive.sh <<EOF
1
y
y
y
y
y
y
n
n
n
n
EOF

## start ssh
service ssh restart

## start mosquitto
service mosquitto restart

# backup sh and change sh to bash
mv /bin/sh /bin/sh.bak
ln -s bash /bin/sh

# if all boot process working, do inifinity loop. it makes the pod keep running.
while true; do sleep 30; done; 
