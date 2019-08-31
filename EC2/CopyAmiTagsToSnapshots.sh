#!/bin/bash


REGIONS=`aws ec2 describe-regions --region us-east-1 | jq .Regions[].RegionName -r`

for REGION in $REGIONS
do
	IMAGEIDS=`aws ec2 describe-images --region $REGION --owner "301206952450" --query "Images[*].ImageId" | jq ".[]" | tr -d ", \""`

	for image in $IMAGEIDS
	do
		TAGS=`aws ec2 describe-images --region $REGION --image-id $image --query "Images[*].Tags[*]" | jq .[] | jq .[]`
		type=`echo $TAGS | jq '. | select(.Key=="type")' | jq .Value | tr -d "\""`
		name=`echo $TAGS | jq '. | select(.Key=="Name")' | jq .Value | tr -d "\""`
		customer=`echo $TAGS | jq '. | select(.Key=="Customer")' | jq .Value | tr -d "\""`
		env=`echo $TAGS | jq '. | select(.Key=="env")' | jq .Value | tr -d "\""`

		SNAPSHOTID=`aws ec2 describe-images --region $REGION --image-ids  $image | jq '.Images[].BlockDeviceMappings[].Ebs.SnapshotId' -r | grep -v "null"`

		for snapshot in $SNAPSHOTID
		do
			if [ -n "$env" ]
			then
				aws ec2 create-tags --resources $snapshot --tags Key=env,Value=$env --region $REGION
			fi

			if [ -n "$customer" ]
			then
			aws ec2 create-tags --resources $snapshot --tags Key=Customer,Value=$customer --region $REGION
			fi

			if [ -n "$type" ]
			then
				aws ec2 create-tags --resources $snapshot --tags Key=type,Value=$type --region $REGION
			fi

			if [ -n "$name" ]
			then
				aws ec2 create-tags --resources $snapshot --tags Key=Name,Value=$name --region $REGION
			fi
		done
	done
done