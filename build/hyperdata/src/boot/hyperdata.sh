#!/bin/bash
set +e

. $DEPLOY_HOME/set_envs.sh

service mosquitto restart

export SKIP_RECREATE_SCHEMA="Y"
export SKIP_RECREATE_ROLE_AND_PERMISSION="Y"
export SKIP_RECREATE_ADMIN="Y"
bash $HD_HOME/config/gen_hd_config.sh
bash $HD_HOME/scripts/install_interactive.sh <<EOF
1
y
y
y
y
y
n
n
n
n
y
EOF

# run as daemon
java -jar $HD_HOME/dist/spring/hyperdata-spring8.4.0.jar &
