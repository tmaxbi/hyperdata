#!/bin/bash

function create_vol() {
  /opt/nifi/nifi-current/conf/ozone-conf/bin/ozone sh volume create ${2}
  sleep 5
  /opt/nifi/nifi-current/conf/ozone-conf/bin/ozone sh bucket create ${2}/${3}
}

function stop_process() {
  echo ${1}
  curl -i -X PUT -H 'Content-Type: application/json' -d '{"id":"'${1}'","state":"STOPPED"}' http://localhost:8080/nifi-api/flow/process-groups/${1} 
  curl -i -X PUT -H 'Content-Type: application/json' -d '{"id":"'${1}'","state":"DISABLED"}' http://localhost:8080/nifi-api/flow/process-groups/${1} 
}

function valid_vol() {
  VALID=$(/opt/nifi/nifi-current/conf/ozone-conf/bin/ozone sh bucket list ${2} | grep ${3})
  FILES=$(ls /opt/nifi/nifi-current/config-data/${4} | grep "core-site_${2}_${3}.xml")
  echo $VALID
  if [[ -n $VALID ]]; then
    if [[ -n $FILES ]]; then
      stop_process ${5}
    fi
  fi
}

case "${1:-}" in
create)
  create_vol "${@}"
  ;;
valid)
  valid_vol "${@}"
  ;;
esac
