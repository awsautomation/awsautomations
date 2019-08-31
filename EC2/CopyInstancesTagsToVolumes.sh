#!/bin/bash

REGIONS=`aws ec2 describe-regions --region us-east-1 | jq .Regions[].RegionName -r`

### INSTANCES To VOLUMES

for REGION in $REGIONS
do
	INSTANCES=`aws ec2 describe-instances --region $REGION --owner "301206952450" --query "Reservations[*].Instances[*].InstanceId" | jq ".[]" | tr -d ", \""`

	for instance in $INSTANCES
	do
		TAGS=`aws ec2 describe-instances --region $REGION --instance-id $instance --query "Reservations[*].Instances[*].Tags[*]" | jq .[] | jq .[] | jq .[]`
		type=`echo $TAGS | jq '. | select(.Key=="type")' | jq .Value | tr -d "\""`
		name=`echo $TAGS | jq '. | select(.Key=="Name")' | jq .Value | tr -d "\""`
		customer=`echo $TAGS | jq '. | select(.Key=="Customer")' | jq .Value | tr -d "\""`
		env=`echo $TAGS | jq '. | select(.Key=="env")' | jq .Value | tr -d "\""`

		VOLUMEIDS=`aws ec2 describe-instances --region $REGION --instance-id  $instance | jq '.Reservations[].Instances[].BlockDeviceMappings[].Ebs.VolumeId' -r | grep -v "null"`

		for volume in $VOLUMEIDS
		do
			if [ -n "$env" ]
			then
				aws ec2 create-tags --resources $volume --tags Key=env,Value=$env --region $REGION
			fi

			if [ -n "$customer" ]
			then
			aws ec2 create-tags --resources $volume --tags Key=Customer,Value=$customer --region $REGION
			fi

			if [ -n "$type" ]
			then
				aws ec2 create-tags --resources $volume --tags Key=type,Value=$type --region $REGION
			fi

			if [ -n "$name" ]
			then
				aws ec2 create-tags --resources $volume --tags Key=Name,Value=$name --region $REGION
			fi
		done
	done
done



### INSTANCES To VPCS

for REGION in $REGIONS
do
	INSTANCES=`aws ec2 describe-instances --region $REGION --owner "301206952450" --query "Reservations[*].Instances[*].InstanceId" | jq ".[]" | tr -d ", \""`

	for instance in $INSTANCES
	do
		TAGS=`aws ec2 describe-instances --region $REGION --instance-id $instance --query "Reservations[*].Instances[*].Tags[*]" | jq .[] | jq .[] | jq .[]`
		type=`echo $TAGS | jq '. | select(.Key=="type")' | jq .Value | tr -d "\""`
		name=`echo $TAGS | jq '. | select(.Key=="Name")' | jq .Value | tr -d "\""`
		customer=`echo $TAGS | jq '. | select(.Key=="Customer")' | jq .Value | tr -d "\""`
		env=`echo $TAGS | jq '. | select(.Key=="env")' | jq .Value | tr -d "\""`

		VPCIDS=`aws ec2 describe-instances --region $REGION --instance-id $instance | jq '.Reservations[].Instances[].VpcId' -r | grep -v "null"`

		for vpc in $VPCIDS
		do
			if [ -n "$env" ]
			then
				aws ec2 create-tags --resources $vpc --tags Key=env,Value=$env --region $REGION
			fi

			if [ -n "$customer" ]
			then
			aws ec2 create-tags --resources $vpc --tags Key=Customer,Value=$customer --region $REGION
			fi

			if [ -n "$type" ]
			then
				aws ec2 create-tags --resources $vpc --tags Key=type,Value=$type --region $REGION
			fi

			if [ -n "$name" ]
			then
				aws ec2 create-tags --resources $vpc --tags Key=Name,Value=$name --region $REGION
			fi
		done
	done
done


### VPCS To NAT GW

for REGION in $REGIONS
do
	VPCS=`aws ec2 describe-vpcs --region us-east-2 | jq '.Vpcs[].VpcId' -r`

	for vpcid in $VPCS
	do
		TAGS=`aws ec2 describe-vpcs --region $REGION --vpc-id $vpcid | jq '.Vpcs[].Tags[]' -r`
		type=`echo $TAGS | jq '. | select(.Key=="type")' | jq .Value | tr -d "\""`
		name=`echo $TAGS | jq '. | select(.Key=="Name")' | jq .Value | tr -d "\""`
		customer=`echo $TAGS | jq '. | select(.Key=="Customer")' | jq .Value | tr -d "\""`
		env=`echo $TAGS | jq '. | select(.Key=="env")' | jq .Value | tr -d "\""`

		NATGWS=`aws ec2 describe-nat-gateways --region $REGION | jq '.NatGateways[] | select(.VpcId=='\"$vpcid\"').NatGatewayId' -r`

		for natgw in $NATGWS
		do
			if [ -n "$env" ]
			then
				aws ec2 create-tags --resources $vpc --tags Key=env,Value=$env --region $REGION
			fi

			if [ -n "$customer" ]
			then
			aws ec2 create-tags --resources $vpc --tags Key=Customer,Value=$customer --region $REGION
			fi

			if [ -n "$type" ]
			then
				aws ec2 create-tags --resources $vpc --tags Key=type,Value=$type --region $REGION
			fi

			if [ -n "$name" ]
			then
				aws ec2 create-tags --resources $vpc --tags Key=Name,Value=$name --region $REGION
			fi
		done
	done
done


### REDIS To Snapshots

for REGION in $REGIONS
do
	REDIS=`aws elasticache describe-cache-clusters --region us-east-1 | jq '.CacheClusters[].CacheClusterId' -r`

	for redis in $REDIS
	do
		TAGS=`aws elasticache list-tags-for-resource --resource-name arn:aws:elasticache:$REGION:301206952450:cluster:$redis --region $REGION | jq '.[]' | jq '.[]'`
		type=`echo $TAGS | jq '. | select(.Key=="type")' | jq .Value | tr -d "\""`
		name=`echo $TAGS | jq '. | select(.Key=="Name")' | jq .Value | tr -d "\""`
		customer=`echo $TAGS | jq '. | select(.Key=="Customer")' | jq .Value | tr -d "\""`
		env=`echo $TAGS | jq '. | select(.Key=="env")' | jq .Value | tr -d "\""`

		SNAPSHOTS=`aws elasticache describe-snapshots --region $REGION | jq '.Snapshots[] | select(.CacheClusterId=='\"$redis\"').SnapshotName' -r`

		for natgw in $NATGWS
		do
			if [ -n "$env" ]
			then
				aws ec2 create-tags --resources $vpc --tags Key=env,Value=$env --region $REGION
			fi

			if [ -n "$customer" ]
			then
			aws ec2 create-tags --resources $vpc --tags Key=Customer,Value=$customer --region $REGION
			fi

			if [ -n "$type" ]
			then
				aws ec2 create-tags --resources $vpc --tags Key=type,Value=$type --region $REGION
			fi

			if [ -n "$name" ]
			then
				aws ec2 create-tags --resources $vpc --tags Key=Name,Value=$name --region $REGION
			fi
		done
	done
done