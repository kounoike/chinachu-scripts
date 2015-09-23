#!/bin/bash

PID=$1
RULES_FILE=$2
RESERVES_FILE=$3
SCHEDULE_DATA_FILE=$4

LOGDIR=$(dirname $0)/logs
LOG=${LOGDIR}/reserve_start.log
JQ=$(dirname $0)/jq-linux64


RESERVES_BAK=${LOGDIR}/${PID}_old_$(basename $RESERVES_FILE)

date >> $LOG
echo "RULE:$RULES_FILE RESERVES:$RESERVES_FILE SCHEDULE:$SCHEDULE_DATA_FILE" >> $LOG

$JQ 'map({key: .id, value: .}) | from_entries' ${RESERVES_FILE} > ${RESERVES_BAK}
