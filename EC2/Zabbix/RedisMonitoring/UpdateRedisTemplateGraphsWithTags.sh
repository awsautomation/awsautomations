#!/bin/bash
#get the relevant Key for a private ip address 
REDISES=`./GetRedisInstancesTags.sh | awk -F"," '{print $1","$2}' | sort | uniq`

for redisline in $REDISES 
do

cat Items/SearchGraphs.json | sed "s/\$GRAPHNAME/$redisline/g" >Items/tmp/SearchGraphs.json
GRAPHS=`curl -H "Content-Type: application/json" --data @Items/tmp/SearchGraphs.json http://10.2.104.138/zabbix/api_jsonrpc.php | jq .result[].graphid | sed 's/\"/\",/2' | tr -d '\n' | sed s'/.$//'`
cat Items/RemoveGraphs.json | sed "s/\$GRAPHIDS/`echo $GRAPHS`/g"   >Items/tmp/RemoveGraphs.json
curl -H "Content-Type: application/json" --data @Items/tmp/RemoveGraphs.json http://10.2.104.138/zabbix/api_jsonrpc.php


BytesUsedForCache=`echo "BytesUsedForCache - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$BytesUsedForCache/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$BytesUsedForCache/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php


NetworkBytesIn=`echo "NetworkBytesIn - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$NetworkBytesIn/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$NetworkBytesIn/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php


NetworkBytesOut=`echo "NetworkBytesOut - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$NetworkBytesOut/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$NetworkBytesOut/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php


SwapUsage=`echo "SwapUsage - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$SwapUsage/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$SwapUsage/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php


CPUUtilization=`echo "CPUUtilization - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$CPUUtilization/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$CPUUtilization/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php


CurrConnections=`echo "CurrConnections - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$CurrConnections/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$CurrConnections/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php


Evictions=`echo "Evictions - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$Evictions/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$Evictions/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php


FreeableMemory=`echo "FreeableMemory - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$FreeableMemory/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$FreeableMemory/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php


CacheHits=`echo "CacheHits - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$CacheHits/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$CacheHits/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

CacheMisses=`echo "CacheMisses - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$CacheMisses/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$CacheMisses/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

CurrItems=`echo "CurrItems - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$CurrItems/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$CurrItems/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

GetTypeCmds=`echo "GetTypeCmds - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$GetTypeCmds/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$GetTypeCmds/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

HashBasedCmds=`echo "HashBasedCmds - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$HashBasedCmds/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$HashBasedCmds/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

KeyBasedCmds=`echo "KeyBasedCmds - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$KeyBasedCmds/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$KeyBasedCmds/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

ListBasedCmds=`echo "ListBasedCmds - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$ListBasedCmds/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$ListBasedCmds/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

NewConnections=`echo "NewConnections - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$NewConnections/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$NewConnections/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

Reclaimed=`echo "Reclaimed - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$Reclaimed/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$Reclaimed/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

ReplicationLag=`echo "ReplicationLag - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$ReplicationLag/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$ReplicationLag/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

SetBasedCmds=`echo "SetBasedCmds - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$SetBasedCmds/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$SetBasedCmds/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

SetTypeCmds=`echo "SetTypeCmds - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$SetTypeCmds/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$SetTypeCmds/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

SortedSetBasedCmds=`echo "SortedSetBasedCmds - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$SortedSetBasedCmds/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$SortedSetBasedCmds/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

StringBasedCmds=`echo "StringBasedCmds - $redisline"`
cat Items/itemsearchinfo.json | sed "s/\$SEARCHKEY/$StringBasedCmds/g" >Items/tmp/itemsearchinfo.json
GetGraphItems=`curl -H "Content-Type: application/json" --data @Items/tmp/itemsearchinfo.json http://10.2.104.138/zabbix/api_jsonrpc.php`
SedGraphItems=`echo $GetGraphItems | jq '.result[] | {itemid: .itemid}| tostring' -r | sed -e "s/\}/\},/g" | sed '$s/\,//'| sed -e "s/\}/,\ \"calc_fnc\":\ \"7\",\"drawtype\":\ \"2\",\"color\":\ \"\\\$RANDCOLOR\"\}/g"`
cat Items/AddRedisGraph.json | sed "s/\$NAME/$StringBasedCmds/g;s/\$GRAPHITEMS/`echo $SedGraphItems`/g"   >Items/tmp/AddRedisGraph.json
./ChangeColors.sh
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGraph.json http://10.2.104.138/zabbix/api_jsonrpc.php

done
