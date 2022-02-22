#!/bin/bash

. /opt/hadoop/ssvr5/ssvr5-env.sh /opt/hadoop/ssvr5

#### Coordinator Setting & Execute ####

if [ "$IS_OM" = "Y" ]; then
  sed -i "s/STORAGE_TYPE=.*/STORAGE_TYPE=OZONE/g" /opt/hadoop/ssvr5/client/config/java_agent.config
  sed -i 's/OM_HOST=.*/OM_HOST='"$(hostname -I | rev | cut -c 2- | rev)"'/g' /opt/hadoop/ssvr5/client/config/java_agent.config
  sed -i "s/SCM_HOST=.*/SCM_HOST=$SCM_POD_IP/g" /opt/hadoop/ssvr5/client/config/java_agent.config
  gen-ssvr5-metadb.sh 
  ssvr5-boot-coordinator.sh 
  type5agent run 
fi

#### Datanode agent Setting & Execute ####

if [ "$IS_DATANODE" = "Y" ]; then
  OM_SVC_IP=$(nslookup om | grep Address | tail -1 | tr -d 'Address : ')
  sed -i "1s/.*/$OM_SVC_IP/g" /opt/hadoop/ssvr5/config/ssvr5_datanode.config
  gen-ssvr5-metadb.sh
  ssvr5-boot-datanode.sh
fi
