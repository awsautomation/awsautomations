#!/bin/bash
#get the relevant Key for a private ip address 

REGIONS=`aws ec2 describe-regions --query "Regions[*].RegionName[]" --output text`

for region in $REGIONS 
do
RDSES=`aws rds describe-db-instances --region $region | jq .DBInstances[].DBInstanceIdentifier -r`
for rds in $RDSES
do
echo $rds,$region
done
done
