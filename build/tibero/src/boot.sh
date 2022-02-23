#!/bin/sh

cp /deploy_src/src/hadoop/hadoop_classpath.conf ~/.bashrc
. ~/.bashrc

if [ -d $HADOOP_HOME ]; then 
  echo "Hadoop already exists."
  echo "alias tlog='tail -f /db/tibero6/instance/tibero/log/slog/sys.log'" >> ~/.bashrc
  . ~/.bashrc
else 
  sh /deploy_src/src/hadoop/install.sh 
fi

if [ $PV_RECOVERY="Y" ]; then
  echo "Start PV Recovery and tbboot"
else
  tar -xzf /deploy_src/src/tibero/*.tar.gz -C /db/
  if [ -d $TB_HOME/database ]; then
    echo "Tibero already exists."
    sh /deploy_src/src/tibero/sync_hostip.sh
  else
    sh /deploy_src/src/tibero/install.sh
  fi
tbboot
tbdown immediate
. ~/.bashrc
tbboot
fi

chmod 750 $TB_HOME/instance/$TB_SID/log
find $TB_HOME/instance/$TB_SID/log -type f -name '*.log' -exec chmod 640 {} \;
#chmod -R 640 $TB_HOME/database/$TB_SID/log/*.log
chmod -R 640 $TB_HOME/database/$TB_SID/*.ctl
chmod -R 640 $TB_HOME/database/$TB_SID/*.log
chmod -R 640 $TB_HOME/database/$TB_SID/*.dtf
