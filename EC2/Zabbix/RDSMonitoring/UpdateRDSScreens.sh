#!/bin/bash

RDSES=`./GetRDSInstancesTags.sh | awk -F"," '{print $1","$2}' | sort | uniq`
ROW=0
COL=0

#### Update RDS Screen

for record in $RDSES
do
#echo $record
cat Items/SearchGraphs.json | sed "s/\$GRAPHNAME/$record/g" >Items/tmp/SearchGraphs.json
GRAPHS=`curl -H "Content-Type: application/json" --data @Items/tmp/SearchGraphs.json http://10.2.104.138/zabbix/api_jsonrpc.php | jq .result[].graphid -r`

for graph in $GRAPHS
do
#  echo $ROW $COL $graph
  cat Items/UpdateRDSScreen.json | sed "s/\$ROW/$ROW/g;s/\$COL/$COL/g;s/\$GRAPH/$graph/g" >Items/tmp/UpdateRDSScreen.json
  curl -H "Content-Type: application/json" --data @Items/tmp/UpdateRDSScreen.json http://10.2.104.138/zabbix/api_jsonrpc.php

if [ $COL == 15 ]
    then
        let COL=0
        let ROW++
    else
        let COL++
fi
done
done
