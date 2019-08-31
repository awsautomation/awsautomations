#!/bin/bash
#get the relevant Key for a private ip address 

REGIONS=`aws ec2 describe-regions --query "Regions[*].RegionName[]" --output text --region us-east-1`

for region in $REGIONS 
do
REDISES=`aws elasticache describe-cache-clusters --region $region | jq .CacheClusters[].CacheClusterId -r`
for redis in $REDISES
do
redistype=`aws elasticache list-tags-for-resource --resource-name arn:aws:elasticache:$region:301206952450:cluster:$redis --region $region | jq '.TagList[] | tostring' -c -r | jq ' select(.Key=="type")' | jq .Value -r`
redisenv=`aws elasticache list-tags-for-resource --resource-name arn:aws:elasticache:$region:301206952450:cluster:$redis --region $region | jq '.TagList[] | tostring' -c -r | jq ' select(.Key=="env")' | jq .Value -r` 
echo $redistype,$redisenv,$redis,$region
done
done
