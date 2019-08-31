#!/bin/bash


SGOrigin=$1
OriginRegion=$2
Description=$3
VPCID=$4
TargetRegion=$5
Creds=$6

aws ec2 describe-security-groups --region $OriginRegion --group-ids $SGOrigin

NewSG=`AWS_SHARED_CREDENTIALS_FILE=/root/.aws/$Creds aws ec2 create-security-group --description "$Description" --region $TargetRegion --group-name "$Description" --vpc-id $VPCID | jq '.GroupId' -r`

aws ec2 describe-security-groups --region $OriginRegion --group-ids $SGOrigin | jq '.SecurityGroups[]' > tmp/alljson.json

numofrules=`aws ec2 describe-security-groups --region $OriginRegion --group-ids $SGOrigin | jq '.SecurityGroups[].IpPermissions[]' | grep "IpProtocol" | wc -l`

if [ "$numofrules" -eq "1" ]
then
	aws ec2 describe-security-groups --region $OriginRegion --group-ids $SGOrigin | jq '.SecurityGroups[].IpPermissions[]' > /tmp/onerule.json
	fromport=`cat /tmp/onerule.json | jq '.FromPort' -r`
        toport=`cat /tmp/onerule.json | jq '.ToPort' -r`
        protocol=`cat /tmp/onerule.json | jq '.IpProtocol' -r`
        numofcidr=`cat /tmp/onerule.json | jq '.IpRanges[].CidrIp' -r | wc -l`
	if [ "$numofcidr" -eq "1" ]
	then
		cidr=`cat /tmp/onerule.json | jq '.IpRanges[].CidrIp' -r`
                AWS_SHARED_CREDENTIALS_FILE=/root/.aws/$Creds aws ec2 authorize-security-group-ingress --group-id $NewSG --protocol $protocol --region $TargetRegion --cidr $cidr
	
	else
		for ((counter = 0 ; counter < $numofcidr ; counter++ ))
        	do
			if [ "$protocol" == "-1" ]
        		then
        			cidr=`cat /tmp/onerule.json | jq '.IpRanges['$counter'].CidrIp' -r`
        		        AWS_SHARED_CREDENTIALS_FILE=/root/.aws/$Creds aws ec2 authorize-security-group-ingress --group-id $NewSG --protocol $protocol --region $TargetRegion --cidr $cidr

        		else
        		        cidr=`cat /tmp/onerule.json | jq '.IpRanges['$counter'].CidrIp' -r`
        		        AWS_SHARED_CREDENTIALS_FILE=/root/.aws/$Creds aws ec2 authorize-security-group-ingress --group-id $NewSG --protocol $protocol --port $toport --region $TargetRegion --cidr $cidr
        		fi
		done
	fi
else
	for ((i = 0 ; i < $numofrules ; i++ ))
	do
		protocol=`aws ec2 describe-security-groups --region $OriginRegion --group-ids $SGOrigin | jq '.SecurityGroups[].IpPermissions['$i']' | jq '.IpProtocol' -r`
		aws ec2 describe-security-groups --region $OriginRegion --group-ids $SGOrigin | jq '.SecurityGroups[].IpPermissions['$i']' > /tmp/$i.json
		fromport=`cat /tmp/$i.json | jq '.FromPort' -r`
		toport=`cat /tmp/$i.json | jq '.ToPort' -r`
		protocol=`cat /tmp/$i.json | jq '.IpProtocol' -r`
		numofcidr=`cat /tmp/$i.json | jq '.IpRanges[].CidrIp' -r | wc -l`
		for ((counter = 0 ; counter < $numofcidr ; counter++ ))
		do
			if [ "$protocol" == "-1" ]
			then
				cidr=`cat /tmp/$i.json | jq '.IpRanges['$counter'].CidrIp' -r`
				AWS_SHARED_CREDENTIALS_FILE=/root/.aws/$Creds aws ec2 authorize-security-group-ingress --group-id $NewSG --protocol $protocol --region $TargetRegion --cidr $cidr
				
			else
				cidr=`cat /tmp/$i.json | jq '.IpRanges['$counter'].CidrIp' -r`
				AWS_SHARED_CREDENTIALS_FILE=/root/.aws/$Creds aws ec2 authorize-security-group-ingress --group-id $NewSG --protocol $protocol --port $toport --region $TargetRegion --cidr $cidr
			fi
		done
	done
fi
