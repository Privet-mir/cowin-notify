# cowin-notify

Script will check on cowin if slots are available for vaccine in group 18+/45+ and send notification over slack. you can configure it with different platforms such as SMTP/Telegram.

Replace Slack bot token in script with your bot token, follow this link https://api.slack.com/authentication/basics#creating to learn about slack bot
```
curl -F "text=Slots Available in $STATE1/$DISTRICT1 for AGE $AGE18 "  -F channel=$SLACK_ID -F token=xoxb-XXXXXXXXX-XXXXXXXXX-XXXXXXXXXX https://slack.com/api/chat.postMessage
```

Run script using following command
```
$: chmod +x cowin-notify.sh
$: ./cowin-notify.sh Maharashtra Nagpur <SLACK ID> (replace this with your slack id)
```
script will run in infinite loop with a sleep of 30 seconds

For states and district with Space or multiple words use
```
$: ./cowin-notify.sh Karnataka Bangalore_Urban <SLACK ID>
$: ./cowin-notify.sh Madhya_Pradesh Alirajpur <SLACK ID>
```
Just replace space with underscore

You can run this in your local terminal / set as cron / cloud / docker / k8's.
