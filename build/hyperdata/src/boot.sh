#!/bin/bash
set +e

## TODO: install_interactive.sh를 매번 돌리지 않아도 정상적으로 수행되도록 수정

# 1. boot jeus
# jeus에서 set +e를 설정해서 터지면, boot.sh에 set -e 설정되있을 시 터져버림
bash $SRC_HOME/boot/jeus.sh

# 2. boot hyperdata
bash $SRC_HOME/boot/hyperdata.sh

# if all boot process working, do inifinity loop. it makes the pod keep running.
while true; do sleep 30; done; 
