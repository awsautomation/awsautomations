#!/bin/bash

REDISES=`./GetRedisInstancesTags.sh | awk -F"," '{print $1","$2}' | sort | uniq | grep test`
ROW=0
COL=0

#### Update Redis Screen

for record in $REDISES
do
#echo $record
cat Items/SearchScreenGraphs.json | sed "s/\$GRAPHNAME/$record/g" >Items/tmp/SearchScreenGraphs.json
GRAPHS=`curl -H "Content-Type: application/json" --data @Items/tmp/SearchScreenGraphs.json http://10.2.104.138/zabbix/api_jsonrpc.php | jq .result[].graphid -r`

for graph in $GRAPHS
do
#  echo $ROW $COL $graph
  cat Items/UpdateRedisScreenTEST.json | sed "s/\$ROW/$ROW/g;s/\$COL/$COL/g;s/\$GRAPH/$graph/g" >Items/tmp/UpdateRedisScreenTEST.json
  curl -H "Content-Type: application/json" --data @Items/tmp/UpdateRedisScreenTEST.json http://10.2.104.138/zabbix/api_jsonrpc.php

if [ $COL == 21 ]
    then
        let COL=0
        let ROW++
    else
        let COL++
fi
done
done
