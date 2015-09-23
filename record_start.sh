#!/bin/bash

RECORDING=$1
PROGRAM_JSON=$2
JQ=$(dirname $0)/jq-linux64

echo "START: $RECORDING $PROGRAM_JSON" >> /home/chinachu/chinachu-scripts/logs/recorded.log
MSG=$(echo "$PROGRAM_JSON" | $JQ -r '"ID:" + .id + " " + .channel.name + "で「" + .title + "」の録画を開始しました"')

ttytter -ssl -status="$MSG"
