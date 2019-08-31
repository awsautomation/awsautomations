#!/bin/bash

RDSES=`./GetRDSInstancesTags.sh | awk -F"," '{print $1","$2}' | sort | uniq`

for rdsline in $RDSES 
do

cat Items/SearchGraphs.json | sed "s/\$GRAPHNAME/$rdsline/g" >Items/tmp/SearchGraphs.json
GRAPHS=`curl -H "Content-Type: application/json" --data @Items/tmp/SearchGraphs.json http://10.2.104.138/zabbix/api_jsonrpc.php | jq .result[].graphid | sed 's/\"/\",/2' | tr -d '\n' | sed s'/.$//'`
cat Items/RemoveGraphs.json | sed "s/\$GRAPHIDS/`echo $GRAPHS`/g"   >Items/tmp/RemoveGraphs.json
curl -H "Content-Type: application/json" --data @Items/tmp/RemoveGraphs.json http://10.2.104.138/zabbix/api_jsonrpc.php 


BinLogDiskUsage=`echo "BinLogDiskUsage - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$BinLogDiskUsage/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$BinLogDiskUsage/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

CPUUtilization=`echo "CPUUtilization - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$CPUUtilization/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$CPUUtilization/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

DatabaseConnections=`echo "DatabaseConnections - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$DatabaseConnections/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$DatabaseConnections/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

DiskQueueDepth=`echo "DiskQueueDepth - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$DiskQueueDepth/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$DiskQueueDepth/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

FreeableMemory=`echo "FreeableMemory - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$FreeableMemory/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$FreeableMemory/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

FreeStorageSpace=`echo "FreeStorageSpace - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$FreeStorageSpace/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$FreeStorageSpace/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

ReplicaLag=`echo "ReplicaLag - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$ReplicaLag/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$ReplicaLag/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

SwapUsage=`echo "SwapUsage - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$SwapUsage/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$SwapUsage/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

ReadIOPS=`echo "ReadIOPS - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$ReadIOPS/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$ReadIOPS/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

WriteIOPS=`echo "WriteIOPS - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$WriteIOPS/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$WriteIOPS/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

ReadLatency=`echo "ReadLatency - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$ReadLatency/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$ReadLatency/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

WriteLatency=`echo "WriteLatency - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$WriteLatency/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$WriteLatency/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

ReadThroughput=`echo "ReadThroughput - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$ReadThroughput/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$ReadThroughput/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

WriteThroughput=`echo "WriteThroughput - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$WriteThroughput/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$WriteThroughput/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

NetworkReceiveThroughput=`echo "NetworkReceiveThroughput - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$NetworkReceiveThroughput/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$NetworkReceiveThroughput/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

NetworkTransmitThroughput=`echo "NetworkTransmitThroughput - $rdsline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$NetworkTransmitThroughput/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRDSGraph.json | sed "s/\$NAME/$NetworkTransmitThroughput/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRDSGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

done
