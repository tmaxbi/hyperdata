#!/bin/sh

clean_tac() {
    :
}

init_hdfs() { 
    if [ -d $HADOOP_HOME ]; then
        echo "Hadoop already exists."
    else
        sh $SRC_HOME/hadoop/install.sh;
    fi
}

set_value() {

   cp $SRC_HOME/env ~/.bashrc
    . ~/.bashrc

    if [ -d $TB_HOME/database ]; then
        :
    else
        echo "export cnt=0"> $TB_VOLUME/cnt
        chmod +x $TB_VOLUME/cnt
    fi

    if [ $TAS_REDUN -eq 1 ]; then
        redun="EXTERNAL"
    elif [ $TAS_REDUN -eq 2 ]; then
        redun="NORMAL"
    else
        redun="HIGH"
    fi

    export dd_bs=$(($TAS_DISK_SIZE * 1024))

    . $TB_VOLUME/cnt
    echo export CM_SID=cm$cnt >> ~/.bashrc
    echo export TB_SID=tac$cnt >> ~/.bashrc
    . ~/.bashrc

    echo "export cnt=`expr $cnt + 1`" > $TB_VOLUME/cnt
}

init_tb() {
    tar -xzf $SRC_HOME/tibero/*.tar.gz -C $TB_VOLUME/
    cp $SRC_HOME/tibero/license.xml $TB_HOME/license/license.xml
    cp -r $SRC_HOME/client $TB_VOLUME/
    mkdir -p $TB_HOME/hd
}

create_cm_tip() {
    echo CM_NAME=cm$cnt >> $CM_HOME/config/cm$cnt.tip
    echo CM_UI_PORT=11000 >> $CM_HOME/config/cm$cnt.tip
    echo CM_RESOURCE_FILE=$CM_HOME/cm$cnt.res >> $CM_HOME/config/cm$cnt.tip
}

create_tas_tip() {
    echo LISTENER_PORT=14000 >> $TB_HOME/config/tas$cnt.tip
    echo THREAD=$cnt >> $TB_HOME/config/tas$cnt.tip
    echo CM_PORT=11000 >> $TB_HOME/config/tas$cnt.tip
    echo LOCAL_CLUSTER_PORT=13000 >> $TB_HOME/config/tas$cnt.tip
    echo TOTAL_SHM_SIZE=$TOTAL_SHM_SIZE >> $TB_HOME/config/tas$cnt.tip
    echo MEMORY_TARGET=$MEMORY_TARGET >> $TB_HOME/config/tas$cnt.tip
    echo MAX_SESSION_COUNT=$MAX_SESSION_COUNT >> $TB_HOME/config/tas$cnt.tip
    echo CLUSTER_DATABASE=Y >> $TB_HOME/config/tas$cnt.tip
    echo BOOT_WITH_AUTO_DOWN_CLEAN=Y >> $TB_HOME/config/tas$cnt.tip
    echo LOCAL_CLUSTER_ADDR=$IP_ADDR >> $TB_HOME/config/tas$cnt.tip
    echo _SLEEP_ON_SIG=Y >> $TB_HOME/config/tas$cnt.tip
    echo INSTANCE_TYPE=AS >> $TB_HOME/config/tas$cnt.tip
    echo AS_ALLOW_ONLY_RAW_DISKS=N >> $TB_HOME/config/tas$cnt.tip
    echo AS_DISKSTRING='"'$TAS_DISK/*'"' >> $TB_HOME/config/tas$cnt.tip
    echo _ACF_NMGR_MAX_NODES=10 >>  $TB_HOME/config/tas$cnt.tip
}

create_tac_tip() {
    echo LISTENER_PORT=10000 >> $TB_HOME/config/tac$cnt.tip
    echo AS_PORT=14000 >> $TB_HOME/config/tac$cnt.tip
    echo CM_PORT=11000 >> $TB_HOME/config/tac$cnt.tip
    echo LOCAL_CLUSTER_PORT=12000 >> $TB_HOME/config/tac$cnt.tip
    echo THREAD=$cnt >> $TB_HOME/config/tac$cnt.tip
    echo UNDO_TABLESPACE=UNDO$cnt >> $TB_HOME/config/tac$cnt.tip
    echo DB_NAME=tac  >> $TB_HOME/config/tac$cnt.tip
    echo SERVER_SIDE_LOAD_BALANCE=SHORT >> $TB_HOME/config/tac$cnt.tip
    echo LOCAL_CLUSTER_ADDR=$IP_ADDR  >> $TB_HOME/config/tac$cnt.tip
    echo CONTROL_FILES=+DS0/c1.ctl  >> $TB_HOME/config/tac$cnt.tip
    echo DB_CREATE_FILE_DEST=+DS0  >> $TB_HOME/config/tac$cnt.tip
    echo LOG_ARCHIVE_DEST=+DS0/archive  >> $TB_HOME/config/tac$cnt.tip
    echo TOTAL_SHM_SIZE=$TOTAL_SHM_SIZE  >> $TB_HOME/config/tac$cnt.tip
    echo MEMORY_TARGET=$MEMORY_TARGET  >> $TB_HOME/config/tac$cnt.tip
    echo MAX_SESSION_COUNT=$MAX_SESSION_COUNT >> $TB_HOME/config/tac$cnt.tip
    echo THROW_WHEN_GETTING_OSSTAT_FAIL=N >> $TB_HOME/config/tac$cnt.tip
    echo BOOT_WITH_AUTO_DOWN_CLEAN=Y >> $TB_HOME/config/tac$cnt.tip
    echo _ALLOW_DIFF_CHARSET_INSTANCE=Y >> $TB_HOME/config/tac$cnt.tip
    echo _SLEEP_ON_SIG=Y  >> $TB_HOME/config/tac$cnt.tip
    echo USE_ACTIVE_STORAGE=Y  >> $TB_HOME/config/tac$cnt.tip
    echo CLUSTER_DATABASE=Y  >> $TB_HOME/config/tac$cnt.tip
    echo _ACF_NMGR_MAX_NODES=10 >>  $TB_HOME/config/tac$cnt.tip
}

create_tbdsn() {
    echo "tas$cnt=((INSTANCE=(HOST=$IP_ADDR)(PORT=14000)(DB_NAME=tas)))" >> $TB_HOME/client/config/tbdsn.tbr
    echo "tac$cnt=((INSTANCE=(HOST=$IP_ADDR)(PORT=10000)(DB_NAME=tac)))"  >> $TB_HOME/client/config/tbdsn.tbr
}

create_1st_sql() {
    echo "create database \"tac\"" >> $TB_HOME/hd/tac$cnt.sql
    echo "user sys identified by tibero" >> $TB_HOME/hd/tac$cnt.sql
    echo "maxinstances 10" >> $TB_HOME/hd/tac$cnt.sql
    echo "maxdatafiles 200" >> $TB_HOME/hd/tac$cnt.sql
    echo "character set UTF8" >> $TB_HOME/hd/tac$cnt.sql
    echo "logfile group 0 '+DS0/log000.log' size $LOG_FILE_SIZE," >> $TB_HOME/hd/tac$cnt.sql
    echo "group 1 '+DS0/log001.log' size $LOG_FILE_SIZE," >> $TB_HOME/hd/tac$cnt.sql
    echo "group 2 '+DS0/log002.log' size $LOG_FILE_SIZE" >> $TB_HOME/hd/tac$cnt.sql
    echo "maxloggroups 255" >> $TB_HOME/hd/tac$cnt.sql
    echo "maxlogmembers 8" >> $TB_HOME/hd/tac$cnt.sql
    echo "$ARCHIVE_MODE" >> $TB_HOME/hd/tac$cnt.sql
    echo "datafile '+DS0/system001.dtf' size $DATA_FILE_SIZE" >> $TB_HOME/hd/tac$cnt.sql
    echo "autoextend on next 10M maxsize unlimited" >> $TB_HOME/hd/tac$cnt.sql
    echo "default tablespace usr" >> $TB_HOME/hd/tac$cnt.sql
    echo "datafile '+DS0/usr.dtf' size $DATA_FILE_SIZE" >> $TB_HOME/hd/tac$cnt.sql
    echo "autoextend on next 10M" >> $TB_HOME/hd/tac$cnt.sql
    echo "extent management local autoallocate" >> $TB_HOME/hd/tac$cnt.sql
    echo "default temporary tablespace TEMP" >> $TB_HOME/hd/tac$cnt.sql
    echo "tempfile '+DS0/temp001.dtf' size $TEMP_FILE_SIZE" >> $TB_HOME/hd/tac$cnt.sql
    echo "autoextend on next 10M" >> $TB_HOME/hd/tac$cnt.sql
    echo "extent management local autoallocate" >> $TB_HOME/hd/tac$cnt.sql
    echo "undo tablespace UNDO0" >> $TB_HOME/hd/tac$cnt.sql
    echo "datafile '+DS0/undo000.dtf' size $UNDO_FILE_SIZE" >> $TB_HOME/hd/tac$cnt.sql
    echo "autoextend on next 10M" >> $TB_HOME/hd/tac$cnt.sql
    echo "extent management local autoallocate;" >> $TB_HOME/hd/tac$cnt.sql
    echo "quit;" >> $TB_HOME/hd/tac$cnt.sql
    
    mkdir -p $TAS_DISK
    
    i=1
    while [ $i -le $TAS_DISK_CNT ]; do
        dd if=/dev/zero of=$TAS_DISK/disk$i bs=$dd_bs count=1048576
        chmod 755 $TAS_DISK/disk$i
        i=$((i+1))
    done
    
    echo CREATE DISKSPACE DS0 $redun REDUNDANCY >> $TB_HOME/hd/tas$cnt.sql
    
    disk_no=1
    i=1
    while [ $i -le $TAS_REDUN  ]; do
        echo "FAILGROUP FG$i DISK" >> $TB_HOME/hd/tas$cnt.sql

        j=1
        while [ $j -le `expr $TAS_DISK_CNT / $TAS_REDUN`  ]; do
            if [ $j -eq `expr $TAS_DISK_CNT / $TAS_REDUN`  ]; then
                echo "'$TAS_DISK/disk$disk_no' NAME FG${i}_DISK${j}" >> $TB_HOME/hd/tas$cnt.sql
            else
                echo "'$TAS_DISK/disk$disk_no' NAME FG${i}_DISK${j}," >> $TB_HOME/hd/tas$cnt.sql
            fi
            disk_no=`expr $disk_no + 1`
            j=$((j+1))
        done
        i=$((i+1))
    done
    
    echo ";" >> $TB_HOME/hd/tas$cnt.sql
    echo "quit;" >> $TB_HOME/hd/tas$cnt.sql
}

create_1st() {
    export TB_SID=tac0 
    tbcm -b
    sleep 2

    cmrctl add network --nettype private --ipaddr $IP_ADDR --portno 15000 --name net1
    cmrctl add cluster --incnet net1  --cfile "+$TAS_DISK/*" --name cls1

    export TB_SID=tas0 
    tbboot nomount
    sleep 2

    tbsql sys/tibero@tas0 @$TB_HOME/hd/tas$cnt.sql

    cmrctl start cluster --name cls1
    sleep 2
    cmrctl add service --name tas --type as --cname cls1
    sleep 2
    cmrctl add service --name tac --cname cls1
    sleep 2

    cmrctl add as --name tas0 --svcname tas --dbhome $CM_HOME
    cmrctl add db --name tac0 --svcname tac --dbhome $CM_HOME

    export TB_SID=tas0 
    tbboot
    sleep 2

    export TB_SID=tac0 
    tbboot nomount

    tbsql sys/tibero@tac0 @$TB_HOME/hd/tac$cnt.sql

    tbboot
    sleep 2

    sh $TB_HOME/scripts/system.sh -p1 tibero -p2 syscat -a1 y -a2 y -a3 y -a4 y
}

create_other_sql() {
    echo "alter diskspace DS0 add thread $cnt;" >> $TB_HOME/hd/tas$cnt.sql
    echo "quit;" >> $TB_HOME/hd/tas$cnt.sql

    group_no1=`expr $cnt \* 3`
    group_no2=`expr $group_no1 + 1`
    group_no3=`expr $group_no1 + 2`


    echo "create undo tablespace undo${cnt} datafile '+DS0/undo00${cnt}.dtf' size $UNDO_FILE_SIZE autoextend on next 10m;" >> $TB_HOME/hd/tac$cnt.sql

    echo "alter database add logfile THREAD $cnt group $group_no1 '+DS0/log00${group_no1}.log' size $LOG_FILE_SIZE;" >> $TB_HOME/hd/tac$cnt.sql
    echo "alter database add logfile THREAD $cnt group $group_no2 '+DS0/log00${group_no2}.log' size $LOG_FILE_SIZE;" >> $TB_HOME/hd/tac$cnt.sql
    echo "alter database add logfile THREAD $cnt group $group_no3 '+DS0/log00${group_no3}.log' size $LOG_FILE_SIZE;" >> $TB_HOME/hd/tac$cnt.sql

    echo "alter database ENABLE PUBLIC THREAD $cnt;" >> $TB_HOME/hd/tac$cnt.sql
    echo "quit;" >> $TB_HOME/hd/tac$cnt.sql
}

create_other() {   
    tbsql sys/tibero@tas0 @$TB_HOME/hd/tas$cnt.sql
    tbsql sys/tibero@tac0 @$TB_HOME/hd/tac$cnt.sql

    tbcm -b
    sleep 2

    cmrctl add network --nettype private --ipaddr $IP_ADDR --portno 15000 --name net1
    cmrctl add cluster --incnet net1  --cfile "+$TAS_DISK/*" --name cls1
    
    cmrctl start cluster --name cls1
    sleep 2

    cmrctl add as --name tas$cnt --svcname tas --dbhome $CM_HOME
    cmrctl add db --name tac$cnt --svcname tac --dbhome $CM_HOME

    export TB_SID=tas$cnt 
    tbboot
    sleep 2

    export TB_SID=tac$cnt 
    tbboot
    sleep 5
}

### MAIN
init_hdfs
set_value

if [ -d $TB_HOME/database ]; then
    :
else
    init_tb
fi

create_cm_tip
create_tas_tip
create_tac_tip
create_tbdsn

if [ -d $TB_HOME/database ]; then
    create_other_sql
    create_other
else
    create_1st_sql
    create_1st
fi