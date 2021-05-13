# cowin-notify

Script will check on cowin if slots are available it will send notification over slack. you can configure it with different platforms such as SMTP/Telegram.

Run script using following command
```
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
