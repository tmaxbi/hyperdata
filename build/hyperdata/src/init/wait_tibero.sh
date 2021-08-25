#!/bin/bash
# tibero가 init될때까지 tibero command가 실패할 수 있으므로, 실패해도 init container가 종료되지 않도록 set -e undo.
set +e

. $DEPLOY_HOME/set_envs.sh

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