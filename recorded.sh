#!/bin/bash

RECORDED=$1
PROGRAM_JSON=$2
JQ=$(dirname $0)/jq-linux64

. $(dirname $0)/env/bin/activate

LOG=/home/chinachu/chinachu-scripts/logs/recorded.log

echo "END: $RECORDED $PROGRAM_JSON" >> $LOG

MSG=$(echo "$PROGRAM_JSON" | $JQ -r '"ID:" + .id + " " + .channel.name + "で「" + .title + "」の録画を終了しました"')

# ttytter -ssl -status="$MSG"

ID=$(echo "$PROGRAM_JSON" | $JQ -r '.id')

# echo "****DEBUG***** ID:$ID MSG:$MSG" >> $LOG

chmod og+w $RECORDED

sleep 10

python $(dirname $0)/update_status.py "$MSG" $ID

