#!/bin/bash

PROGRAM_JSON=$1
JQ=$(dirname $0)/jq-linux64

echo "PREPARE: $PROGRAM_JSON" >> /home/chinachu/chinachu-scripts/logs/recorded.log
MSG=$(echo "$PROGRAM_JSON" | $JQ -r '"ID:" + .id + " " + .channel.name + "で「" + .title + "」の録画を準備しています"')

ttytter -ssl -status="$MSG"
