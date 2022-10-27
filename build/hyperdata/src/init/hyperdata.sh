#!/bin/bash
set -e

. $DEPLOY_HOME/set_envs.sh

export SKIP_RECREATE_SCHEMA="N"
export SKIP_RECREATE_ROLE_AND_PERMISSION="N"
export SKIP_RECREATE_ADMIN="N"
bash $HD_HOME/config/gen_hd_config.sh

bash $HD_HOME/scripts/install_interactive.sh <<EOF
12
y
y
EOF

bash $HD_HOME/scripts/install_interactive.sh <<EOF
1
y
y
y
y
y
y
y
EOF

# create tibero directory
mkdir -p $TB_VOLUME/input
mkdir -p $TB_VOLUME/output
mkdir -p $TB_VOLUME/meta
mkdir -p $TB_VOLUME/logo
mkdir -p $TB_VOLUME/guide

## create hyperdata dataobject directory
tbsql hyperdata_ex/tmax@"(INSTANCE=(HOST=$TB_IP)(PORT=$TB_PORT)(DB_NAME=$TB_SID))" <<EOF
CREATE OR REPLACE DIRECTORY FILE_DIR AS '$TB_VOLUME/input';
exit;
EOF
