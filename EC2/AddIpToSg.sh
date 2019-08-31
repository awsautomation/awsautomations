#!/bin/bash

IP=$1
OriginIP=$2
profile=$3

for PROFILE in $profile
do
REGION=`aws ec2 describe-regions --query "Regions[*].RegionName[]" --profile $PROFILE --output text --region us-east-1`

	for region in $REGION
	do
		SG=`aws ec2 describe-security-groups --region $region --profile $PROFILE | jq '.SecurityGroups[].GroupId' -r`
	
		for sg in $SG
		do
			Permissions=`aws ec2 describe-security-groups --region $region --group-id $sg --profile $PROFILE | jq '.SecurityGroups[].IpPermissions' | jq '.[] | select(.IpRanges[].CidrIp == '\"$OriginIP\"')' -r`
			numofrules=`aws ec2 describe-security-groups --region $region --group-id $sg --profile $PROFILE | jq '.SecurityGroups[].IpPermissions' | jq '.[] | select(.IpRanges[].CidrIp == '\"$OriginIP\"')' -r | grep "IpProtocol" | wc -l`

			if [ -n "$Permissions" ]
			then
				if [ "$numofrules" -eq "1" ]
				then
				        toport=`echo $Permissions | jq '.ToPort' -r`
					fromport=`echo $Permissions | jq '.FromPort' -r`
					protocol=`echo $Permissions | jq '.IpProtocol' -r`
					aws ec2 authorize-security-group-ingress --group-id $sg --protocol $protocol --port $toport --region $region --cidr $IP --profile $PROFILE
					
						if [ "$protocol" == "-1" ]
	        				then
	        				        aws ec2 authorize-security-group-ingress --group-id $sg --protocol $protocol --region $region --cidr $IP --profile $PROFILE
		
		        			else
		        			        aws ec2 authorize-security-group-ingress --group-id $sg --protocol $protocol --port $toport --region $region --cidr $IP --profile $PROFILE
		        			fi
		
				else
					for ((i = 0 ; i < $numofrules ; i++ ))
					do
						aws ec2 describe-security-groups --region $region --group-ids $sg --profile $PROFILE | jq '.SecurityGroups[].IpPermissions['$i']' > /tmp/$i.json
						fromport=`cat /tmp/$i.json | jq '.FromPort' -r`
						toport=`cat /tmp/$i.json | jq '.ToPort' -r`
						protocol=`cat /tmp/$i.json | jq '.IpProtocol' -r`
						if [ "$protocol" == "-1" ]
						then
							aws ec2 authorize-security-group-ingress --group-id $sg --protocol $protocol --region $region --cidr $IP --profile $PROFILE
		
						else
							aws ec2 authorize-security-group-ingress --group-id $sg --protocol $protocol --port $toport --region $region --cidr $IP --profile $PROFILE
						fi
					done
				fi
			fi
		done
	done
done
