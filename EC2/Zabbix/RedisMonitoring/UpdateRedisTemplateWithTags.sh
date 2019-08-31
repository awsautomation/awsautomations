#!/bin/bash
#get the relevant Key for a private ip address 

REDISES=`./GetRedisInstancesTags.sh`

for redisline in $REDISES 
do
redistype=`echo $redisline | awk -F"," '{print $1}'`
redisenv=`echo $redisline | awk -F"," '{print $2}'`
redis=`echo $redisline | awk -F"," '{print $3}'`
region=`echo $redisline | awk -F"," '{print $4}'`
echo "$redistype $redisenv $redis $region"


cat Items/AddRedisBytesUsedForCacheitem.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisBytesUsedForCacheitem.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisBytesUsedForCacheitem.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisNetworkBytesInitem.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisNetworkBytesInitem.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisNetworkBytesInitem.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisNetworkBytesOutitem.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisNetworkBytesOutitem.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisNetworkBytesOutitem.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisSwapUsageitem.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisSwapUsageitem.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisSwapUsageitem.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisCPUUtilization.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisCPUUtilization.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisCPUUtilization.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisCurrConnections.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisCurrConnections.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisCurrConnections.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisEvictions.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisEvictions.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisEvictions.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisFreeableMemory.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisFreeableMemory.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisFreeableMemory.json http://10.2.104.138/zabbix/api_jsonrpc.php


cat Items/AddRedisCacheHits.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisCacheHits.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisCacheHits.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisCacheMisses.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisCacheMisses.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisCacheMisses.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisCurrItems.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisCurrItems.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisCurrItems.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisGetTypeCmds.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisGetTypeCmds.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisGetTypeCmds.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisHashBasedCmds.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisHashBasedCmds.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisHashBasedCmds.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisKeyBasedCmds.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisKeyBasedCmds.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisKeyBasedCmds.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisListBasedCmds.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisListBasedCmds.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisListBasedCmds.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisNewConnections.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisNewConnections.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisNewConnections.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisReclaimed.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisReclaimed.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisReclaimed.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisReplicationLag.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisReplicationLag.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisReplicationLag.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisSetBasedCmds.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisSetBasedCmds.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisSetBasedCmds.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisSortedSetBasedCmds.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisSortedSetBasedCmds.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisSortedSetBasedCmds.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisStringBasedCmds.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisStringBasedCmds.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisStringBasedCmds.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRedisSetTypeCmds.json | sed "s/\$REDIS/$redis,$region/g;s/\$TYPE,\$ENV/$redistype,$redisenv/g" >Items/tmp/AddRedisSetTypeCmds.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRedisSetTypeCmds.json http://10.2.104.138/zabbix/api_jsonrpc.php



##### Add Triggers


done

##### Add Graphs
#./UpdateRedisTemplateGraphsWithTags.sh

##### Update Screen
#./UpdateRedisScreens.sh


#AddRedisBytesUsedForCacheitem.json
#AddRedisNetworkBytesInitem.json
#AddRedisNetworkBytesOutitem.json
#AddRedisSwapUsageitem.json
#AddRedisCPUUtilization.json
#AddRedisCurrConnections.json
#AddRedisEvictions.json
#AddRedisFreeableMemory.json
#AddRedisCacheHits.json
#AddRedisCacheMisses.json
#AddRedisCurrItems.json
#AddRedisGetTypeCmds.json
#AddRedisHashBasedCmds.json
#AddRedisKeyBasedCmds.json
#AddRedisListBasedCmds.json
#AddRedisNewConnections.json
#AddRedisReclaimed.json
#AddRedisReplicationLag.json
#AddRedisSetBasedCmds.json
#AddRedisSetTypeCmds.json
#AddRedisSortedSetBasedCmds.json
#AddRedisStringBasedCmds.json

