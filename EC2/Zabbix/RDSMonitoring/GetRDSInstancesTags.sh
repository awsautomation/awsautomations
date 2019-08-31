#!/bin/bash
#get the relevant Key for a private ip address 

REGIONS=`aws ec2 describe-regions --query "Regions[*].RegionName[]" --output text --region us-east-1` 

for region in $REGIONS 
do
RDSES=`aws rds describe-db-instances --region $region | jq .DBInstances[].DBInstanceIdentifier -r`
for rds in $RDSES
do
rdstype=`aws rds list-tags-for-resource --resource-name arn:aws:rds:$region:301206952450:db:$rds --region $region | jq '.TagList[] | tostring' -c -r | jq ' select(.Key=="type")' | jq .Value -r`
rdsenv=`aws rds list-tags-for-resource --resource-name arn:aws:rds:$region:301206952450:db:$rds --region $region | jq '.TagList[] | tostring' -c -r | jq ' select(.Key=="env")' | jq .Value -r`
echo $rdstype,$rdsenv,$rds,$region
done
done
