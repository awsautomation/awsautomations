#!/bin/bash

echo -e "\n"

REGIONS=`aws ec2 describe-regions --query "Regions[*].RegionName[]" --output text --region us-west-2`

for region in $REGIONS
do
	rm reserved$region.txt
	touch reserved$region.txt
	rm reservedfinal$region.txt
	touch reservedfinal$region.txt
	rm instances$region.txt
	touch instances$region.txt
	rm tmp/instances$region.txt
        touch tmp/instances$region.txt
	rm instancesautoscaling$region.txt
	touch instancesautoscaling$region.txt

	aws ec2 describe-reserved-instances --region $region --filters "Name=state,Values=active" --query "ReservedInstances[*].{Type:InstanceType,Count:InstanceCount}" | jq .[] | tr -d "{}\"," | tr -s "\n" "\n" | sed 1d > reserved$region.txt

	countercount=1
	countertype=2

	counter=`cat reserved$region.txt | wc -l`
	let counteroflines=$counter/2


	while [ $counter -ge $countertype ]
	do
		count=`cat reserved$region.txt | sed -n "$countercount"p | awk -F ":" '{print $2}' | tr -d " "`
		type=`cat reserved$region.txt | sed -n "$countertype"p | awk -F ":" '{print $2}' | tr -d " "`
		echo "$count $type" >> reservedfinal$region.txt
		let countercount=countercount+2
		let countertype=countertype+2
	done


	aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceType" --region $region | jq .[] | tr -d "[] " | sort | grep "^\"" | tr -d "\"" | uniq -c | tr -s "\t" " " > instances$region.txt

	aws ec2 describe-instances --filters Name=instance-state-name,Values=running Name=tag-key,Values=autoscaling Name=tag-key,Values=autoscaling Name=tag-value,Values=true --query "Reservations[*].Instances[*].InstanceType" --region $region | jq .[] | tr -d "[] " | sort | grep "^\"" | tr -d "\"" | uniq -c | tr -s "\t" " " > instancesautoscaling$region.txt


	while read line
        do
                instancetype=`echo $line | awk -F " " '{print $2}'`
                instancecount=`echo $line | awk -F " " '{print $1}'`
                CHECK=`cat instancesautoscaling$region.txt | grep "$instancetype"`

                if [ -n "$CHECK" ]
                then
                        instanceautoscalingcount=`cat instancesautoscaling$region.txt | grep $instancetype | awk -F " " '{print $1}'`
			let finalinstancecount=$instancecount-$instanceautoscalingcount
			finalline=`echo "$finalinstancecount $instancetype"`
			cat instances$region.txt | sed "s/$line/$finalline/g" > tmp/instances$region.txt
			cp tmp/instances$region.txt instances$region.txt
		fi
        done < instances$region.txt

	while read line
	do
		reservedtype=`echo $line | awk -F " " '{print $2}'`
		reservedcount=`echo $line | awk -F " " '{print $1}'`
		CHECK=`cat instances$region.txt | grep "$reservedtype"`

		if [ -n "$CHECK" ]
		then
			instancecount=`cat instances$region.txt | grep $reservedtype | awk -F " " '{print $1}'`
			if [ $reservedcount -gt $instancecount ]
			then
				echo "There are less running instances ($instancecount) than reserved instances ($reservedcount) of $reservedtype in $region"
			else
                                echo "Verified $region - There are exactly or less reserved instances than running instances"
			fi
		else
			echo "There are no running instances of $reservedtype while there are $reservedcount reserved instances in $region"
		fi
	done < reservedfinal$region.txt
done


##### Calculate the difference between number of running instances and number of reserved instances #####

echo -e "\n"
echo -e "The difference between the running instances and the reserved instances are:\n"

REGIONS=`aws ec2 describe-regions --query "Regions[*].RegionName[]" --output text --region us-west-2`

for region in $REGIONS
do
	echo -e "##### $region #####\n"
	while read line
	do
	                instancetype=`echo $line | awk -F " " '{print $2}'`
	                instancecount=`echo $line | awk -F " " '{print $1}'`
	                CHECK=`cat reservedfinal$region.txt | grep "$instancetype"`
			CHECKDUPLICATE=`cat reservedfinal$region.txt | grep "$instancetype" | wc -l`
	
	                if [ -n "$CHECK" ]
	                then
				if [ -n $CHECKDUPLICATE ]
				then
					if [ $CHECKDUPLICATE -gt "1" ]
					then
						cat reservedfinal$region.txt | grep $instancetype | awk -F " " '{print $1}' > duplicate$instancetype.txt
						sum=0
						while read c
						do
							let sum=sum+$c
						done < duplicate$instancetype.txt
						cat reservedfinal$region.txt | grep -v $instancetype > tmp/reservedfinalduplicate$region.txt
						echo "$sum $instancetype" >> tmp/reservedfinalduplicate$region.txt
						cp tmp/reservedfinalduplicate$region.txt reservedfinal$region.txt
					fi
				fi
	                        reservedcount=`cat reservedfinal$region.txt | grep $instancetype | awk -F " " '{print $1}'`
				if [ -n "$reservedcount" ]
				then
		                        if [ $instancecount -gt $reservedcount ]
		                        then
						let difference=$instancecount-$reservedcount
						echo "$instancetype: $difference"
		                        fi
				fi
			else
                                echo "$instancetype: $instancecount"
	                fi
	done < tmp/instances$region.txt
	echo -e "\n"
done

