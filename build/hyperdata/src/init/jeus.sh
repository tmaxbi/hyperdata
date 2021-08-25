#!/bin/bash
set -e

. $DEPLOY_HOME/set_envs.sh

mkdir -p $JEUS_HOME
cp -r $DEPLOY_HOME/jeus8/* $JEUS_HOME

chmod -R 755 $JEUS_HOME/lib/etc/ant/bin
cd $JEUS_HOME/setup
ant install

chmod -R 750 $JEUS_HOME
find $JEUS_HOME/domains/ -type f -name '*.xml' -exec chmod 700 {} \;
find $JEUS_HOME/domains/ -type d -name 'logs' -exec chmod 750 {} \;
find $JEUS_HOME/domains/ -type f -name '*.log*' -exec chmod 640 {} \;
find $JEUS_HOME/domains/ -type d -name 'logs' -exec setfacl -m d:u::7,d:g::5,d:o::0 {} \;
find $JEUS_HOME/domains/ -type f -name '*.log*' -exec setfacl -m d:u::6,d:g::4,d:o::0 {} \;
find $JEUS_HOME/domains/ -type f -name 'accounts.xml' -exec chmod 600 {} \;
