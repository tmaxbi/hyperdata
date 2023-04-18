FROM apache/ozone:1.2.1
MAINTAINER BIQA <BIQA@tmax.co.kr>

### 1) Set yum Package
RUN sudo yum install -y libaio lrzsz openssh-server openssh-clients unzip bind-utils &&\
       sudo localedef -f UTF-8 -i ko_KR ko_KR.utf8

### 2) Set Global Env
ENV DEPLOY_HOME=/opt/hadoop \
       LANG=ko_KR.utf8 \
       LC_ALL=ko_KR.utf8

## ENTRYPOINT ["/bin/sh", "-c", "/opt/hadoop/boot.sh"]
