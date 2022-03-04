#!/bin/bash

export BACKEND_IP=`ifconfig|awk '{print $2}'|sed -n '2p'|awk -F ':' '{print $2}'`

cp -r /db/src/client /db/
cp /db/src/tibero/license.xml $TB_HOME/license/license.xml
cp /db/src/tibero/tbdsn.tbr $TB_HOME/client/config/
cp /db/src/tibero/*.tip $TB_HOME/config/
sed -i "s/HOST=localhost/HOST=${BACKEND_IP}/g" ${TB_HOME}/client/config/tbdsn.tbr

chmod 640 $TB_HOME/config/$TB_SID.tip
chmod 640 $TB_HOME/client/config/tbdsn.tbr

if [ -z $LSNR_INVITED_IP ]; then
     sed -i "s/LSNR_INVITED_IP=.*/#LSNR_INVITED_IP=/g" $TB_HOME/config/*.tip
else
     sed -i "s/LSNR_INVITED_IP=.*/LSNR_INVITED_IP=$LSNR_INVITED_IP/g" $TB_HOME/config/*.tip
fi

if [ $TB_PORT ]; then
     find $TB_HOME/config/ -name "*.tip" -exec sed -i "s/LISTENER_PORT=8629/LISTENER_PORT=$TB_PORT/g" {} \;
     find $TB_HOME/client/config -name "*.tbr" -exec sed -i "s/PORT=8629/PORT=$TB_PORT/g" {} \;
fi

if [ $MAX_SESSION_COUNT ]; then 
     find $TB_HOME/config/ -name "*.tip" -exec sed -i "s/MAX_SESSION_COUNT=20/MAX_SESSION_COUNT=$MAX_SESSION_COUNT/g" {} \;
fi

if [ $TOTAL_SHM_SIZE ]; then 
     find $TB_HOME/config/ -name "*.tip" -exec sed -i "s/TOTAL_SHM_SIZE=2/TOTAL_SHM_SIZE=$TOTAL_SHM_SIZE/g" {} \;
fi

if [ $MEMORY_TARGET ]; then 
     find $TB_HOME/config/ -name "*.tip" -exec sed -i "s/MEMORY_TARGET=4/MEMORY_TARGET=$MEMORY_TARGET/g" {} \;
fi

if [ $LOG_BUFFER ]; then 
     find $TB_HOME/config/ -name "*.tip" -exec sed -i "s/LOG_BUFFER=200M/LOG_BUFFER=$LOG_BUFFER/g" {} \;
fi

if [ $LOG_GROUP ]; then 
     find $TB_HOME/bin/ -name "tbctl" -exec sed -i "s/log_group=3/log_group=$LOG_GROUP/g" {} \;
fi

if [ $LOG_FILE_SIZE ]; then 
     find $TB_HOME/bin/ -name "tbctl" -exec sed -i "s/log_size=50M/log_size=$LOG_FILE_SIZE/g" {} \;
fi

if [ $SYSTEM_FILE_SIZE ]; then 
     find $TB_HOME/bin/ -name "tbctl" -exec sed -i "s/system_size=100M/system_size=$SYSTEM_FILE_SIZE/g" {} \;
fi

if [ $TEMP_FILE_SIZE ]; then 
     find $TB_HOME/bin/ -name "tbctl" -exec sed -i "s/temp_size=100M/temp_size=$TEMP_FILE_SIZE/g" {} \;
fi

if [ $UNDO_FILE_SIZE ]; then 
     find $TB_HOME/bin/ -name "tbctl" -exec sed -i "s/undo_size=200M/undo_size=$UNDO_FILE_SIZE/g" {} \;
fi

if [ $USR_FILE_SIZE ]; then 
     find $TB_HOME/bin/ -name "tbctl" -exec sed -i "s/usr_size=100M/usr_size=$USR_FILE_SIZE/g" {} \;
fi

find $TB_HOME/bin/ -name "tbctl" -exec sed -i "s/system_next_size=10M/system_next_size=100M/g" {} \;
find $TB_HOME/bin/ -name "tbctl" -exec sed -i "s/temp_next_size=10M/temp_next_size=100M/g" {} \;
find $TB_HOME/bin/ -name "tbctl" -exec sed -i "s/undo_next_size=10M/undo_next_size=100M/g" {} \;
find $TB_HOME/bin/ -name "tbctl" -exec sed -i "s/usr_next_size=10M/usr_next_size=100M/g" {} \;

if [ $DB_CHARACTER_SET ]; then 
     sh $TB_HOME/bin/tb_create_db.sh -ch $DB_CHARACTER_SET
else
     sh $TB_HOME/bin/tb_create_db.sh -ch UTF8
fi
