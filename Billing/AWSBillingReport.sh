#!/bin/bash -x

rm tmp/*.html
rm tmp/BillingReport.csv

GRANULARITY="$1"
monthdayvar=""

if [ "$GRANULARITY" == "MONTHLY" ]
then
	monthdayvar=`date -d "2 months ago" '+%Y-%m-01'`
	EndDate=`date --date="0 day ago" +"%Y"-"%m"-"01" || date -v-0d +"%Y"-"%m"-"%d"`
else
	monthdayvar=`date --date="4 days ago" +"%Y"-"%m"-"%d" || date -v-4d +"%Y"-"%m"-"%d"`
	EndDate=`date --date="2 days ago" +"%Y"-"%m"-"%d" || date -v-2d +"%Y"-"%m"-"%d"`
fi

TodayDate=`date --date="0 day ago" +"%Y"-"%m"-"%d" || date -v-0d +"%Y"-"%m"-"%d"`
#checkDate=`date --date="0 day ago" +"%Y"-"%m"-"%d" | awk -F "-" '{print $3}'`

#if [ $checkDate -eq 01 ]
#then
#	GRANULARITY="MONTHLY"
#	monthdayvar=`date -d"1 $(date -d'2 months ago' +%b)" '+%F'`
#	EndDate=`date --date="0 day ago" +"%Y"-"%m"-"01" || date -v-0d +"%Y"-"%m"-"%d"`
#else
#	GRANULARITY="DAILY"
#	monthdayvar=`date --date="2 days ago" +"%Y"-"%m"-"%d" || date -v-2d +"%Y"-"%m"-"%d"`
#	EndDate=`date --date="0 day ago" +"%Y"-"%m"-"%d" || date -v-0d +"%Y"-"%m"-"%d"`
#fi

#StartDate=`date --date="3 days ago" +"%Y"-"%m"-"%d" || date -v-3d +"%Y"-"%m"-"%d"`

#aws organizations list-accounts | jq '.[] | select(.Status=="ACTIVE")' > OrgList.txt
aws organizations list-accounts | jq '[.Accounts[] | select(.Status=="ACTIVE")]' > OrgList.txt

#aws ce get-cost-and-usage --time-period Start=$monthdayvar,End=$EndDate --granularity $GRANULARITY --metrics UnblendedCost AmortizedCost --group-by Type=DIMENSION,Key=LINKED_ACCOUNT > CostAndUsage.txt
cat input.json | jq .TimePeriod.Start=\"$monthdayvar\" | jq .TimePeriod.End=\"$EndDate\" | jq .Granularity=\"$GRANULARITY\" > inputResults.json

aws ce get-cost-and-usage --cli-input-json file://inputResults.json --region us-east-1 > CostAndUsage.txt
i=0
j=0
k=0

TotalAmortized1=0
TotalUnblended1=0
TotalUnblended2=0
TotalAmortized2=0
endDay1=""
endDay2=""

daysLength=`cat CostAndUsage.txt | jq '.ResultsByTime | length '`
orgListLength=`cat OrgList.txt | jq '. | length '`

while [ "$i" -ne "$daysLength" ]
do
	accountLength=`cat CostAndUsage.txt | jq '.ResultsByTime['$i'].Groups | length'`
	beginDate=`cat CostAndUsage.txt | jq '.ResultsByTime['$i'].TimePeriod.Start' -r`
	endDayDate=`cat CostAndUsage.txt | jq '.ResultsByTime['$i'].TimePeriod.End' -r`
	while [ "$j" -ne "$accountLength" ]
	do
		accountID=`cat CostAndUsage.txt | jq '.ResultsByTime['$i'].Groups['$j'].Keys' | jq .[] -r`
		while [ "$k" -ne "$orgListLength" ]
		do
			IDToCheck=`cat OrgList.txt | jq '.['$k'].Id ' -r`
			if [ "$IDToCheck" == "$accountID" ]
			then
				accountName=`cat OrgList.txt | jq '.['$k'].Name ' -r`
				tempUnblendedCost=`cat CostAndUsage.txt | jq '.ResultsByTime['$i'].Groups['$j'].Metrics.UnblendedCost.Amount' -r`
				accountUnblendedCost=`printf "%0.2f" $tempUnblendedCost`
				tempArmotizedCost=`cat CostAndUsage.txt | jq '.ResultsByTime['$i'].Groups['$j'].Metrics.AmortizedCost.Amount' -r`
				accountArmotizedCost=`printf "%0.2f" $tempArmotizedCost`
				LINE=`echo -e "$accountName,$IDToCheck,$accountUnblendedCost,$accountArmotizedCost,$beginDate,$endDayDate"`
				echo "$LINE" >> BillingReport.csv
				if [ $i -eq "0" ]
				then
					TotalUnblended1=$(echo "$TotalUnblended1+$accountUnblendedCost" | bc )
					TotalAmortized1=$(echo "$TotalAmortized1+$accountArmotizedCost" | bc )
					endDay1=`cat CostAndUsage.txt | jq '.ResultsByTime['$i'].TimePeriod.End' -r`
				else
					TotalUnblended2=$(echo "$TotalUnblended2+$accountUnblendedCost" | bc )
					TotalAmortized2=$(echo "$TotalAmortized2+$accountArmotizedCost" | bc )
					endDay2=`cat CostAndUsage.txt | jq '.ResultsByTime['$i'].TimePeriod.End' -r`
				fi
			fi
			let "k++"
		done
		k=0
		let "j++"
	done
	j=0
	let "i++"
done

cat BillingReport.csv | sort > newReport.csv

counter=1
counterline=`cat newReport.csv | wc -l`

#checkNewCustomer=`cat newReport.csv  | awk -F "," '{print $2}' | uniq -c | sed -e 's/[ \t]*//' | grep '^1'`

while [ "$counter" -le "$counterline" ]
do
	line1check=`cat newReport.csv | sed -n ${counter}p | awk -F "," '{print $1}'`
	let counter=counter+1
	line2check=`cat newReport.csv | sed -n ${counter}p | awk -F "," '{print $1}'`
	if [ "$line1check" == "$line2check" ]
	then
		let counter=counter-1
		line1=`cat newReport.csv | sed -n ${counter}p`
		let counter=counter+1
		line2=`cat newReport.csv | sed -n ${counter}p`
		ACCOUNTNAME=`echo $line1 | awk -F "," '{print $1}'`
		ACCOUNTID=`echo $line1 | awk -F "," '{print $2}'`
		UNBLENDED1=`echo $line1 | awk -F "," '{print $3}'`
		UNBLENDED2=`echo $line2 | awk -F "," '{print $3}'`
		ARMOTIZED1=`echo $line1 | awk -F "," '{print $4}'`
		ARMOTIZED2=`echo $line2 | awk -F "," '{print $4}'`
		STARTDATE1=`echo $line1 | awk -F "," '{print $5}'`
		STARTDATE2=`echo $line2 | awk -F "," '{print $5}'`
		checkyear1Date=`echo "$STARTDATE1" | awk -F "-" '{print $1}'`
		checkyear2Date=`echo "$STARTDATE2" | awk -F "-" '{print $1}'`
		checkmonth1Date=`echo "$STARTDATE1" | awk -F "-" '{print $2}'`
		checkmonth2Date=`echo "$STARTDATE2" | awk -F "-" '{print $2}'`
		checkday1Date=`echo "$STARTDATE1" | awk -F "-" '{print $3}'`
		checkday2Date=`echo "$STARTDATE2" | awk -F "-" '{print $3}'`

		flagBig="date2"
		date1="$STARTDATE1"
		date2="$STARTDATE2"

		if [ "$checkyear1Date" -ne "$checkyear2Date" ]
		then
			if [ "$checkyear1Date" -gt "$checkyear2Date" ]
			then
				flagBig="date1"
			else
				flagBig="date2"
			fi
		elif [ "$checkmonth1Date" -ne "$checkmonth2Date" ]
		then
			if [ "$checkmonth1Date" -gt "$checkmonth2Date" ]
			then
				flagBig="date1"
			else
				flagBig="date2"
			fi
		elif [ "$GRANULARITY" == "DAILY" ]
		then
			if [ "$checkday1Date" -gt "$checkday2Date" ]
			then
				flagBig="date1"
			else
				flagBig="date2"
			fi
		fi

		if [ "$flagBig" == "date1" ]
		then
			date1="$STARTDATE2"
			date2="$STARTDATE1"

			temp1="$UNBLENDED2"
			UNBLENDED2="$UNBLENDED1"
			UNBLENDED1="$temp1"

			temp1="$ARMOTIZED2"
			ARMOTIZED2="$ARMOTIZED1"
			ARMOTIZED1="$temp1"
		fi

		direction=""

		if (( $(echo "$UNBLENDED1 < $UNBLENDED2" | bc -l) ))
		then
			direction="up"
			percents=`lua -e "print(($UNBLENDED1-$UNBLENDED2)/$UNBLENDED1)"`
			percentss=`lua -e "print(($percents*100))" | cut -c 1-5 | tr -d "-"`
			if [ "$percentss" -lt "0" ]
			then
				percentss=`echo "$percentss * (-1)" | bc -l`
			fi
			percent=`echo $percentss | cut -c 1-5`
		elif (( $(echo "$UNBLENDED1 > $UNBLENDED2" | bc -l) ))
		then
			direction="down"
			percents=`lua -e "print(($UNBLENDED1-$UNBLENDED2)/$UNBLENDED1)"`
			percentss=`lua -e "print(($percents*100))" | cut -c 1-5 | tr -d "-"`
			if [ "$percentss" -lt "0" ]
			then
				percentss=`echo "$percentss * (-1)" | bc -l`
			fi
			percent=`echo $percentss | cut -c 1-5`
		else
			direction="equal"
			percent="0.00"
		fi

	cat div.txt | sed "s/\$ACCOUNTNAME/$ACCOUNTNAME/g;s/\$DIRECTION/$direction/g;s/\$UNBLENDED1/\$$UNBLENDED1/g;s/\$UNBLENDED2/\$$UNBLENDED2/g;s/\$AMORTIZED1/\$$ARMOTIZED1/g;s/\$AMORTIZED2/\$$ARMOTIZED2/g;s/\$STARTDATE1/$date1/g;s/\$STARTDATE2/$date2/g;s/\$PERCENT/$percent/g" > tmp/$ACCOUNTID.html

	#next line is not same customer
	else
		let counter=counter-1
		line1=`cat newReport.csv | sed -n ${counter}p`
		ACCOUNTNAME=`echo $line1 | awk -F "," '{print $1}'`
		ACCOUNTID=`echo $line1 | awk -F "," '{print $2}'`
		UNBLENDED1=`echo $line1 | awk -F "," '{print $3}'`
		AMORTIZED1=`echo $line1 | awk -F "," '{print $4}'`
		STARTDATE1=`echo $line1 | awk -F "," '{print $5}'`
		temp2=$STARTDATE1
		direction="equal"
		percent="0.00"
		cat div2.txt | sed "s/\$ACCOUNTNAME/$ACCOUNTNAME/g;s/\$DIRECTION/$direction/g;s/\$UNBLENDED1/\$$UNBLENDED1/g;s/\$AMORTIZED1/\$$AMORTIZED1/g;s/\$STARTDATE1/$temp2/g;s/\$PERCENT/$percent/g" > tmp/$ACCOUNTID.html
	fi

		let counter=counter+1

done < newReport.csv



ACCOUNTIDSPLATFORM=`cat newReport.csv | awk -F "," '{print $2}' | uniq | grep -E "301206952450|051199467232|871273793151"`
for accountid in $ACCOUNTIDSPLATFORM
do
	cat tmp/${accountid}.html >> tmp/finalplatform.html
done

FINALPLATFORM=`cat tmp/finalplatform.html`

ACCOUNTIDSAPPROVALS=`cat newReport.csv | awk -F "," '{print $2}' | uniq | grep -E "403178227705|576028135886|654841564804|959810345317|647865048321|273282471175|535095460051|507686342620|727100857985|601034546960"`
for accountid in $ACCOUNTIDSAPPROVALS
do
	cat tmp/${accountid}.html >> tmp/finalapprovals.html
done

FINALAPPROVALS=`cat tmp/finalapprovals.html`

ACCOUNTIDSMANAGEMENT=`cat newReport.csv | awk -F "," '{print $2}' | uniq | grep -E "195841307717|809151261099|643532121568|507574732377|565256583383"`
for accountid in $ACCOUNTIDSMANAGEMENT
do
	cat tmp/${accountid}.html >> tmp/finalmanagement.html
done

FINALMANAGEMENT=`cat tmp/finalmanagement.html`

ACCOUNTIDSAUTOMATION=`cat newReport.csv | awk -F "," '{print $2}' | uniq | grep -E "059585313418"`
for accountid in $ACCOUNTIDSAUTOMATION
do
	cat tmp/${accountid}.html >> tmp/finalautomation.html
done

FINALAUTOMATION=`cat tmp/finalautomation.html`

ACCOUNTIDSDEMOENVS=`cat newReport.csv | awk -F "," '{print $2}' | uniq | grep -E "902421041114"`
for accountid in $ACCOUNTIDSDEMOENVS
do
	cat tmp/${accountid}.html >> tmp/finaldemoenvs.html
done

FINALDEMOENVS=`cat tmp/finaldemoenvs.html`

ACCOUNTIDSPARTNERS=`cat newReport.csv | awk -F "," '{print $2}' | uniq | grep -E "153998081217"`
for accountid in $ACCOUNTIDSPARTNERS
do
	cat tmp/${accountid}.html >> tmp/finalpartners.html
done

FINALPARTNERS=`cat tmp/finalpartners.html`

ACCOUNTIDSCUSTOMERS=`cat newReport.csv | awk -F "," '{print $2}' | uniq | grep -vE "403178227705|195841307717|576028135886|654841564804|959810345317|647865048321|153998081217|643532121568|507574732377|273282471175|535095460051|727100857985|301206952450|051199467232|871273793151|507686342620|601034546960|565256583383|059585313418|902421041114|809151261099"`
for accountid in $ACCOUNTIDSCUSTOMERS
do
	cat tmp/${accountid}.html >> tmp/finalcustomers.html
done

FINALCUSTOMERS=`cat tmp/finalcustomers.html`

mv BillingReport.csv tmp/BillingReport.csv
mv CostAndUsage.txt tmp/CostAndUsage.txt
mv OrgList.txt tmp/OrgList.txt
mv newReport.csv tmp/newReport.csv

cat << EOF > tmp/index.html
<html>
<head meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>Capriza AWS Billing</title>
</head>

<img src="http://s.capriza.com/images/capriza-logo.png" width="128" height="128"/>

<h1 style="color: black; font-size: 18px;">AWS $GRANULARITY Billing Report</h1>

<h2 style="color: black; font-size: 16px;">$monthdayvar \$$TotalUnblended1 (\$$TotalAmortized1) </h2>
<h2 style="color: black; font-size: 16px;">$endDay1 \$$TotalUnblended2 (\$$TotalAmortized2) </h2>

<h3 style="color: black; font-size: 20px;">Platform</h3>

<div class="container" style="margin: auto;">
	$FINALPLATFORM

<h3 style="color: black; font-size: 20px;">Approvals</h3>

<div class="container" style="margin: auto;">
	$FINALAPPROVALS

<h3 style="color: black; font-size: 20px;">Customers</h3>

<div class="container" style="margin: auto;">
	$FINALCUSTOMERS

<h3 style="color: black; font-size: 20px;">Management</h3>

<div class="container" style="margin: auto;">
	$FINALMANAGEMENT

<h3 style="color: black; font-size: 20px;">Automation</h3>

<div class="container" style="margin: auto;">
	$FINALAUTOMATION

<h3 style="color: black; font-size: 20px;">DemoEnvs</h3>

<div class="container" style="margin: auto;">
	$FINALDEMOENVS

<h3 style="color: black; font-size: 20px;">Partners</h3>
	$FINALPARTNERS

</div>
</html>

EOF

#aws ses send-email --from "awsbillingreport@capriza.com" --destination "ToAddresses=nick.erenburg@capriza.com" --region us-east-1 --subject "Daily AWS Billing Report - $TodayDate" --html file://tmp/index.html

#aws ses send-email --from "awsbillingreport@capriza.com" --destination "ToAddresses=nick.erenburg@capriza.com,tomer.liberman@capriza.com,ops@capriza.com" --region us-east-1 --subject "Daily AWS Billing Report - $TodayDate" --html file://tmp/index.html


if [ "$GRANULARITY" == "MONTHLY" ]
then
	aws ses send-email --from "awsbillingreport@capriza.com" --destination "ToAddresses=nick.erenburg@capriza.com,ops@capriza.com,ido.ish-hurwitz@capriza.com,yael.lapid@capriza.com,jeff.kennedy@capriza.com,nadav.fischer@capriza.com,doron.oded@capriza.com,igor.katz@capriza.com,elad.azary@capriza.com" --region us-east-1 --subject "Daily AWS Billing Report - $TodayDate" --html file://tmp/index.html
else
	aws ses send-email --from "awsbillingreport@capriza.com" --destination "ToAddresses=nick.erenburg@capriza.com,ops@capriza.com,nadav.fischer@capriza.com,doron.oded@capriza.com,igor.katz@capriza.com,elad.azary@capriza.com" --region us-east-1 --subject "Daily AWS Billing Report - $TodayDate" --html file://tmp/index.html
fi
#aws ses send-email --from "alerts@capriza.com" --destination "ToAddresses=nick.erenburg@capriza.com" --subject "Email With Inline Styling and Image" --html file://emailwithimage.htm

