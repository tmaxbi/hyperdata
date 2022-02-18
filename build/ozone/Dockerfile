FROM 192.168.179.44:5000/ozone_base:20220110_v1
MAINTAINER BIQA <BIQA@tmax.co.kr>

RUN sudo yum install -y libaio
RUN sudo yum install -y lrzsz 
RUN sudo yum install -y openssh-server 
RUN sudo yum install -y openssh-clients 
RUN sudo yum install -y unzip
RUN sudo yum install -y bind-utils

USER hadoop
COPY boot.sh /opt/hadoop/boot.sh
COPY kill.sh /opt/hadoop/kill.sh
COPY ssvr5*.tar.gz /opt/hadoop/ssvr5.tar.gz

WORKDIR /opt/hadoop
RUN tar -xvf ssvr5.tar.gz
RUN mv /opt/hadoop/ssvr5_* /opt/hadoop/ssvr5

RUN sudo chown hadoop:users /opt/hadoop/boot.sh
RUN sudo chown -R hadoop:users /opt/hadoop/ssvr5

#ENTRYPOINT ["/bin/sh", "-c", "/opt/hadoop/boot.sh"]
