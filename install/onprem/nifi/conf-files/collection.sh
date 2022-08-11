#!/bin/bash

function date_create() {
	curYear=`TZ='Asia/Seoul' date '+%Y'`
	curMonth=`TZ='Asia/Seoul' date '+%m'`
	curDay=`TZ='Asia/Seoul' date '+%d'`
	curHour=`TZ='Asia/Seoul' date '+%H'`
	curMin=`TZ='Asia/Seoul' date '+%M'`
	curDateFmt1="${curYear}${curMonth}${curDay}_${curHour}"
	curDateFmt2="${curYear}-${curMonth}-${curDay} ${curHour}:${curMin}"
}

function dir_create() {
	if [[ -d ${logPath} ]]; then
		mkdir -p ${logPath}
	fi
}

function success_log() {
	str="[${curDateFmt2}] [I] Successful collection of $3$2 to $4/$2."
	#echo $str >> ${logPath}/collection_${curDate}.log
    echo $str >> ${logPath}/collection.log
}

function fail_log() {
	str="[${curDateFmt2}] [E] $3$2 file collection failed."
	#echo $str >> ${logPath}/collection_${curDate}.log
    echo $str >> ${logPath}/collection.log
	echo $str >> ${logPath}/collection_fail.log
}


logPath=/opt/nifi/nifi-current/logs/collections
date_create
dir_create

case "${1:-}" in
success)
  success_log "${@}"
  ;;
fail)
  fail_log "${@}"
  ;;
esac
