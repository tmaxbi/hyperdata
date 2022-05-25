FROM 192.168.179.44:5000/ozone_base:20220110_v1
MAINTAINER BIQA <BIQA@tmax.co.kr>

### 1) Set yum Package
RUN sudo yum install -y libaio lrzsz openssh-server openssh-clients unzip bind-utils &&\
	sudo localedef -f UTF-8 -i ko_KR ko_KR.utf8

### 2) Set Global Env
ENV DEPLOY_HOME=/opt/hadoop \
	LANG=ko_KR.utf8 \
	LC_ALL=ko_KR.utf8

### 3) src Copy
COPY --chown=hadoop:users boot.sh $DEPLOY_HOME/boot.sh
COPY --chown=hadoop:users kill.sh $DEPLOY_HOME/kill.sh
COPY ssvr5*.tar.gz $DEPLOY_HOME/ssvr5.tar.gz

RUN tar -xvf ssvr5.tar.gz -C $DEPLOY_HOME \
 && mv $DEPLOY_HOME/ssvr5_* $DEPLOY_HOME/ssvr5 \
 && chown -R hadoop:users $DEPLOY_HOME/ssvr5

## ENTRYPOINT ["/bin/sh", "-c", "/opt/hadoop/boot.sh"]
