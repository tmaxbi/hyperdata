#!/bin/bash
set +e

. $DEPLOY_HOME/set_envs.sh

# startDomainAdminServer에서 에러가 발생하지 않아도, set -e 설정할 경우 터짐
# error code를 반환하는 것으로 보임
startDomainAdminServer -u jeus -p jeus

jeusadmin -u jeus -p jeus "modify-web-engine-configuration -server adminServer -alf combined"
jeusadmin -u jeus -p jeus "disable-webadmin"
$JEUS_HOME/bin/stopServer -host localhost:9736 -u jeus -p jeus
# $JEUS_HOME/bin/startDomainAdminServer -u jeus -p jeus
