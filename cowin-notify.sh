#!/bin/bash

STATE=$1
STATE1=$(echo $STATE | tr '_' ' ')
DISTRICT=$2
DISTRICT1=$(echo $DISTRICT | tr  '_' ' ')
SLACK_ID=$3
DATE=$(TZ=Asia/Kolkata date +"%d-%m-%Y")
	if [ -f "state-list" ]; then
		echo "states list exists"
	else
		curl --location --request GET 'https://cdn-api.co-vin.in/api/v2/admin/location/states' --header 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36' | jq . > state-list
	
	fi

while :
  do
	if [ -f "$STATE-$SLACK_ID-district" ]; then
		echo "district list exists"
	else
		if [ -z "$STATE1" ]; then
	
			STATE_ID=$(cat state-list | jq '.states[] | select(.state_name=="'$STATE'") | .state_id')
		else
			STATE_ID=$(cat state-list | jq '.states[] | select(.state_name=="'"$STATE1"'") | .state_id')
		fi
		curl --location --request GET https://cdn-api.co-vin.in/api/v2/admin/location/districts/$STATE_ID --header 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36' | jq . > $STATE-$SLACK_ID-district
	
	fi
	
	if [ -z "$DISTRICT1" ]; then
		
		DISTRICT_ID=$(cat $STATE-$SLACK_ID-district | jq '.districts[] | select(.district_name=="'$DISTRICT'") | .district_id')
	else
		DISTRICT_ID=$(cat $STATE-$SLACK_ID-district | jq '.districts[] | select(.district_name=="'"$DISTRICT1"'") | .district_id')
	fi
	
	curl --location --request GET "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$DISTRICT_ID&date=$DATE"  --header 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36' | jq . > $DISTRICT-$SLACK_ID-slots
	
	cat $DISTRICT-$SLACK_ID-slots | jq -e '..|select(type == "array" and length == 0)'
	if [ $? -eq 0 ]; then
		echo "No slots available, will recheck in 40s"
	else
	 	AGE45=$(cat $DISTRICT-$SLACK_ID-slots | jq '.centers[].sessions[] | select(.available_capacity!=0) | .min_age_limit | select(.==45)')
		AGE18=$(cat $DISTRICT-$SLACK_ID-slots | jq '.centers[].sessions[] | select(.available_capacity!=0) | .min_age_limit | select(.==18)')
		if [ -z "$AGE45" ]; then
			echo "Not Available for 45+"
		else
			AGE45=$(echo $AGE45 | tr '\n' ' ' | cut -d ' ' -f1)
			AGE45=$AGE45+
			curl -F "text=Slots Available in $STATE1/$DISTRICT1 for AGE $AGE45"  -F channel=$SLACK_ID -F token=xoxb-XXXXXXXXX-XXXXXXXXX-XXXXXXXXXX https://slack.com/api/chat.postMessage
		fi
		if [ -z "$AGE18" ]; then
	                echo "Not Available for 18+"
	        else
	                AGE18=$(echo $AGE18 | tr '\n' ' ' | cut -d ' ' -f1)
	                AGE18=$AGE18+
			curl -F "text=Slots Available in $STATE1/$DISTRICT1 for AGE $AGE18 "  -F channel=$SLACK_ID -F token=xoxb-XXXXXXXXX-XXXXXXXXX-XXXXXXXXXX https://slack.com/api/chat.postMessage
	        fi
	
	fi
     echo "will run after 30 second"
     sleep 30
  done
