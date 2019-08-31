#!/bin/bash

REDISES=`./GetRedisInstancesTags.sh | awk -F"," '{print $1","$2}' | sort | uniq`
ROW=0
COL=0

#### Update Redis Screen

for record in $REDISES
do
#echo $record
cat Items/SearchGraphs.json | sed "s/\$GRAPHNAME/$record/g" >Items/tmp/SearchGraphs.json
GRAPHS=`curl -H "Content-Type: application/json" --data @Items/tmp/SearchGraphs.json http://10.2.104.138/zabbix/api_jsonrpc.php | jq .result[].graphid -r`

for graph in $GRAPHS
do
#  echo $ROW $COL $graph
  cat Items/UpdateRedisScreen.json | sed "s/\$ROW/$ROW/g;s/\$COL/$COL/g;s/\$GRAPH/$graph/g" > Items/tmp/UpdateRedisScreen.json
  curl -H "Content-Type: application/json" --data @Items/tmp/UpdateRedisScreen.json http://10.2.104.138/zabbix/api_jsonrpc.php

if [ $COL == 21 ]
    then
        let COL=0
        let ROW++
    else
        let COL++
fi
done
done

./UpdateRedisScreenDEV.sh
./UpdateRedisScreenTEST.sh
./UpdateRedisScreenPROD.sh
