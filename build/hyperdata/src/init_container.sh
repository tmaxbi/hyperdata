#!/bin/bash

## TODO: install_interactive.sh를 매번 돌리지 않아도 정상적으로 수행되도록 수정

# set envs
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
. $parent_path/set_envs.sh

# 1. check until tibero init
echo "Initialize hyperdata start."
echo "Wait until the tibero is running. timeout 600 seconds."
start_time=$(date +%s)
while true; do
  # check is tbprobe return zero
  code=$(tbprobe $TB_IP:$TB_PORT && echo $?)
  if [ "$code" = "0" ]; then
    # check is tibero sid is created
    tb_login_check=$(tbsql tibero/tmax@"(INSTANCE=(HOST=$TB_IP)(PORT=$TB_PORT)(DB_NAME=$TB_SID))" <<EOF
exit;
EOF
    )
    if [[ $tb_login_check == *"Connected to Tibero"* ]]; then
      break
    fi
  fi

  cur_time=$(date +%s)
  time_diff=$((cur_time-start_time))
  if [ $time_diff -gt 600 ]; then
    echo "TBPROBE always failed. please check your tibero."
    exit 1
  fi

  sleep 30
done

# 2. init hyperdata
if [ ! -f $TB_MOUNT_VOLUME_PATH/HD_SCHEMA_VERSION ]; then
  # if no hyperdata version exists

  ## init hadoop
  # if [ -d $HADOOP_VOLUME/krb5_conf ]; then echo "krb5 dir already exists."; else mkdir $HADOOP_VOLUME/krb5_conf; fi
  # if [ -f $HADOOP_VOLUME/krb5_conf/krb5.conf ]; then echo "krb5.conf file already exists."; else cp $ROOT_HOME/hadoop/krb5.conf $HADOOP_VOLUME/krb5.conf; fi
  # rm -rf /etc/krb5.conf
  # ln -s /db/krb5_conf/krb5.conf /etc/krb5.conf;

  ## init jeus
  chmod -R 755 $JEUS_HOME/lib/etc/ant/bin
  cd $JEUS_HOME/setup
  ant install

  ## install hyperdata
  export SKIP_RECREATE_SCHEMA="N"
  export SKIP_RECREATE_ROLE_AND_PERMISSION="N"
  export SKIP_RECREATE_ADMIN="N"
  echo "Cannot find hyperdata schema version file. regard uninitialized."
  bash $HD_HOME/config/gen_hd_config.sh
  bash $HD_HOME/scripts/install_interactive.sh <<EOF
1
y
y
y
y
y
y
y
y
EOF
  ## create hyperdata dataobject directory
  tbsql hyperdata_ex/tmax@"(INSTANCE=(HOST=$TB_IP)(PORT=$TB_PORT)(DB_NAME=$TB_SID))" <<EOF
CREATE OR REPLACE DIRECTORY FILE_DIR AS '$TB_VOLUME/input';
exit;
EOF
  ## save schema version in Tibero PVC
  echo $HD_SCHEMA_VERSION > $TB_MOUNT_VOLUME_PATH/HD_SCHEMA_VERSION
fi
