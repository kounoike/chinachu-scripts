#!/bin/bash

PID=$1
ID=$2
START=$3
CH=$4
TITLE=$5
JSON=$6

LOG=$(dirname $0)/logs/conflict.log

date >> $LOG
echo "CONFLICT ID:$ID START:$START CH:$CH TITLE:$TITLE" >> $LOG
echo "$JSON" | jq . >> $LOG
