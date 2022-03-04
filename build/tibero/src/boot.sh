#!/bin/sh

cp /db/src/hadoop/hadoop_classpath.conf ~/.bashrc
echo "alias tlog='tail -f /db/tibero6/instance/tibero/log/slog/sys.log'" >> ~/.bashrc
. ~/.bashrc

if [ -d $HADOOP_HOME ]; then 
  echo "Hadoop already exists."
else 
  sh /db/src/hadoop/install.sh;
fi

tar -xzf /db/src/tibero/*.tar.gz -C /db/

if [ -d $TB_HOME/database ]; then
  echo "Tibero already exists."
  sh /db/src/tibero/sync_hostip.sh;
else
  sh /db/src/tibero/install.sh;
fi

tbboot;
tbdown immediate;
tbboot;

chmod 750 $TB_HOME/instance/$TB_SID/log
find $TB_HOME/instance/$TB_SID/log -type f -name '*.log' -exec chmod 640 {} \;
chmod -R 640 $TB_HOME/database/$TB_SID/*.ctl
chmod -R 640 $TB_HOME/database/$TB_SID/*.log
chmod -R 640 $TB_HOME/database/$TB_SID/*.dtf
