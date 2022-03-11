#!/bin/bash
# set -e 옵션은 에러가 발생했을 시, 더이상 진행하지 않고 bash를 종료하는 명령어입니다.
set -e

## TODO: install_interactive.sh를 매번 돌리지 않아도 정상적으로 수행되도록 수정

# 0. Set Env
source $SRC_HOME/env

# 1. check until tibero init
bash $SRC_HOME/init/wait_tibero.sh

# 2. init hyperdata
if [ ! -f $TB_VOLUME/HD_SCHEMA_VERSION ]; then
  # if no hyperdata version exists
  echo "Cannot find hyperdata schema version file. regard uninitialized."
  
  ## init hadoop
  bash $SRC_HOME/init/hadoop.sh
  
  ## init jeus
  bash $SRC_HOME/init/jeus.sh
   
  ## init hyperdata
  ## bash $SRC_HOME/init/hyperdata.sh
  
  ## save schema version in Tibero PVC
  ## echo $HD_SCHEMA_VERSION > $TB_VOLUME/HD_SCHEMA_VERSION
  
  ## stop proauth
  ## stopServer -host localhost:29736 -u jeus -p jeus
  
  ## stop hyperdata
  ## stopServer -host localhost:19736 -u jeus -p jeus

  ## stop jeus
  ## stopServer -host localhost:9736 -u jeus -p jeus
fi
