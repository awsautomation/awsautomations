#!/bin/bash
######
RDSES=`./GetRDSInstancesTags.sh`

for rdsline in $RDSES 
do
echo $rdsline
rdstype=`echo $rdsline | awk -F"," '{print $1}'`
rdsenv=`echo $rdsline | awk -F"," '{print $2}'`
rds=`echo $rdsline | awk -F"," '{print $3}'`
region=`echo $rdsline | awk -F"," '{print $4}'`
#echo "$rdstype $rdsenv $rds $region"

cat Items/AddRDSBinLogDiskUsage.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSBinLogDiskUsage.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSBinLogDiskUsage.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSCPUUtilization.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSCPUUtilization.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSCPUUtilization.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSDatabaseConnections.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSDatabaseConnections.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSDatabaseConnections.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSDiskQueueDepth.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSDiskQueueDepth.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSDiskQueueDepth.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSFreeableMemory.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSFreeableMemory.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSFreeableMemory.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSFreeStorageSpace.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSFreeStorageSpace.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSFreeStorageSpace.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSReplicaLag.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSReplicaLag.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSReplicaLag.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSSwapUsage.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSSwapUsage.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSSwapUsage.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSReadIOPS.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSReadIOPS.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSReadIOPS.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSWriteIOPS.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSWriteIOPS.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSWriteIOPS.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSReadLatency.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSReadLatency.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSReadLatency.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSWriteLatency.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSWriteLatency.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSWriteLatency.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSReadThroughput.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSReadThroughput.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSReadThroughput.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSWriteThroughput.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSWriteThroughput.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSWriteThroughput.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSNetworkReceiveThroughput.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSNetworkReceiveThroughput.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSNetworkReceiveThroughput.json http://10.2.104.138/zabbix/api_jsonrpc.php

cat Items/AddRDSNetworkTransmitThroughput.json | sed "s/\$RDS/$rds,$region/g;s/\$TYPE,\$ENV/$rdstype,$rdsenv/g" >Items/tmp/AddRDSNetworkTransmitThroughput.json
curl -H "Content-Type: application/json" --data @Items/tmp/AddRDSNetworkTransmitThroughput.json http://10.2.104.138/zabbix/api_jsonrpc.php

done

##### Add Triggers
#./UpdateRDSTriggers.sh

##### Add Graphs
#./UpdateRDSTemplateGraphsWithTags.sh

##### Update Screen
#./UpdateRDSScreens.sh

#AddRDSBinLogDiskUsage.json
#AddRDSCPUUtilization.json          
#AddRDSDatabaseConnections.json     
#AddRDSDiskQueueDepth.json          
#AddRDSFreeableMemory.json          
#AddRDSFreeStorageSpace.json        
#AddRDSReplicaLag.json              
#AddRDSSwapUsage.json               
#AddRDSReadIOPS.json                
#AddRDSWriteIOPS.json               
#AddRDSReadLatency.json             
#AddRDSWriteLatency.json            
#AddRDSReadThroughput.json          
#AddRDSWriteThroughput.json         
#AddRDSNetworkReceiveThroughput.json
#AddRDSNetworkTransmitThroughput.json
