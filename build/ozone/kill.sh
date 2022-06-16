#!/bin/bash

. /opt/hadoop/ssvr5/ssvr5-env.sh /opt/hadoop/ssvr5

ssvr5-stop.sh

if [ "$IS_OM" = "Y" ]; then
  type5agent stop
fi
