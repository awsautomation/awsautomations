#!/bin/bash

IFS=$'\n'
REDISES=`./GetRedisInstancesTags.sh`
METRICS=`cat Items/MetricsList.txt`

for redisline in $REDISES 
do
redistype=`echo $redisline | awk -F"," '{print $1}'`
redisenv=`echo $redisline | awk -F"," '{print $2}'`
redis=`echo $redisline | awk -F"," '{print $3}'`
region=`echo $redisline | awk -F"," '{print $4}'`
for metricline in $METRICS 
do
metric=`echo $metricline | awk -F"\"" '{print $2}'`
comments=`echo $metricline | awk -F"\"" '{print $4}'`
metrictype=`echo $metricline | awk -F"\"" '{print $6}'`
triggertype=`echo $metricline | awk -F"\"" '{print $8}'`

#echo "$redistype $redisenv $redis     $region   $metric           $triggertype $metrictype $comments"
     #logs       prod      redis-logs us-west-2 BytesUsedForCache abnormal10   bytes       The total number of bytes allocated by Redis.

##### Add Triggers
## Configure the trigger parameters
# description = the name of the trigger
# expression  = trigger expression
# comments    = trigger desciption  

case $triggertype in
abnormal30high)
  description="$metric - $redistype,$redisenv,$redis,$region is acting abnormally (30% change) in the last 6 hours"
  expression="(({00__CloudWatch-Redis:AWSCloudWatchRedis[$metric,$redis,$region].avg(6000)}\/{00__CloudWatch-Redis:AWSCloudWatchRedis[$metric,$redis,$region].avg(21600)})>1.3 or ({00__CloudWatch-Redis:AWSCloudWatchRedis[$metric,$redis,$region].avg(6000)}\/{00__CloudWatch-Redis:AWSCloudWatchRedis[$metric,$redis,$region].avg(21600)})<0.7)"
  priority="3"
  ;;
greaterthanzero)
  description="$metric - $redistype,$redisenv,$redis,$region is greater than 0"
  expression="{00__CloudWatch-Redis:AWSCloudWatchRedis[$metric,$redis,$region].last(0)}>0"
  priority="5"
  ;;
greaterthan30)
  description="$metric - $redistype,$redisenv,$redis,$region is greater than 30"
  expression="{00__CloudWatch-Redis:AWSCloudWatchRedis[$metric,$redis,$region].last(0)}>30"
  priority="5"
  ;;
greaterthan512mb)
  description="$metric - $redistype,$redisenv,$redis,$region is greater than 512mb"
  expression="{00__CloudWatch-Redis:AWSCloudWatchRedis[$metric,$redis,$region].last(0)}>536870912"
  priority="5"
 ;;
*)
  echo "ERROR ERROR ERROR NO SUCH TRIGGER TYPE : $triggertypeMessage"
  ;;
esac

#Edit the trigger template
cat Items/TRIGGER.json | sed "s/\$DESCRIPTION/$description/g;s/\$EXPRESSION/$expression/g;s/\$COMMENTS/$comments/g;s/\$PRIORITY/$priority/g" >Items/tmp/AddTrigger.json

#Add the trigger to ZABBIX
curl -H "Content-Type: application/json" --data @Items/tmp/AddTrigger.json http://10.2.104.138/zabbix/api_jsonrpc.php | jq .

done
done
# BytesUsedForCache - logs,prod,redis-logs,us-west-2 AWSCloudWatchRedis[BytesUsedForCache,redis-logs,us-west-2]
#{
#    "jsonrpc": "2.0",
#    "method": "trigger.create",
#    "params": {
#        "description": "$DESCRIPTION",
#        "expression": "$EXPRESSION",
#        "comments": "$COMMENTS",
#        "priority": "$PRIORITY"
#    },
#    "auth": "efa94ec87099957f1da8075b05827135",
#    "id": 1
#}
#        "description": "No Firefox Available for $NAME Less then 25%",
#        "expression": "{00__CloudWatch-Redis:AWSCloudWatchRedis[$KEY].last(0)} < (({00__CloudWatch-Redis:AWSCloudWatchRedis[$KEY].max(43200)})/4)",
#	"priority": "4"

