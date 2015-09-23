#!/bin/bash

PID=$1
RULES_FILE=$2
RESERVES_FILE=$3
SCHEDULE_DATA_FILE=$4
MATCHES=$5
DUPLICATES=$6
CONFLICTS=$7
SKIPS=$8
RESERVES=$9

LOGDIR=$(dirname $0)/logs
LOG=${LOGDIR}/reserve_end.log
DATE=$(date +"%Y%m%d-%H%M%S")

RESERVES_MOD=${LOGDIR}/${PID}_new_$(basename $RESERVES_FILE)
RESERVES_BAK=${LOGDIR}/${PID}_old_$(basename $RESERVES_FILE)

DIFF=${LOGDIR}/${DATE}_${PID}_diff.json
ADD=${LOGDIR}/${DATE}_${PID}_added.txt
DEL=${LOGDIR}/${DATE}_${PID}_deleted.txt
MAIL=${LOGDIR}/${DATE}_${PID}_mail.txt

TO=kounoike.yuusuke@gmail.com

#DEL_TMP=true
DEL_TMP=false

JSONDIFF=$(dirname $0)/node_modules/.bin/json-diff
JQ=$(dirname $0)/jq-linux64

date >> $LOG
echo "PID:$PID RULE:$RULES_FILE RESERVE:$RESERVES_FILE SCHEDULE:$SCHEDULE_DATA_FILE" >> $LOG
echo "MATCHES:$MATCHES DUP:$DUPLICATES CONFLICTS:$CONFLICTS SKIP:$SKIPS RESERVE:$RESERVES" >> $LOG
echo "***********************************************************************" >> $LOG

$JQ 'map({key: .id, value: .}) | from_entries' $RESERVES_FILE > $RESERVES_MOD

$JSONDIFF -j ${RESERVES_BAK} ${RESERVES_MOD} > ${DIFF}

$JQ -r 'to_entries | map(select(.key | endswith("_added")) | .value) | .[] | ("ID: " + .id, .channel.name, .title + " #" + (.episode|tostring) + " 「" + .subTitle + "」", .detail, (.start/1000+9*3600|todate) + "～" + (.["end"]/1000+9*3600|todate), "********************************************")'  ${DIFF} > ${ADD}

$JQ -r 'to_entries | map(select(.key | endswith("_deleted")) | select(.value.start/1000.0 > now) | .value) | .[] | ("ID: " + .id, .channel.name, .title + " #" + (.episode|tostring) + " 「" + .subTitle + "」", .detail, (.start/1000+9*3600|todate) + "～" + (.["end"]/1000+9*3600|todate), "********************************************")' ${DIFF} > ${DEL}


if [ -s $ADD -o -s $DEL ] ; then
    echo "*********Make mail**********" >> $LOG
    date > $MAIL
    if [ -s $ADD ] ; then
        echo "＊＊＊＊＊＊以下の予約が追加されました＊＊＊＊＊＊" >> $MAIL
        cat $ADD >> $MAIL
    fi
    if [ -s $DEL ] ; then
        echo "＊＊＊＊＊＊以下の予約が削除されました＊＊＊＊＊＊" >> $MAIL
        cat $DEL >> $MAIL
    fi
    heirloom-mailx -s "Chianchu スケジューラ" "$TO" < $MAIL
fi

if [ "{$DEL_TMP}" == "{true}" ] ; then
    rm -f $DIFF $ADD $DEL $MAIL
fi
