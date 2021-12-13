#!/bin/bash

#modified from this wonderful tutorial online:
#https://www.howtoforge.com/tutorial/configure-clamav-to-scan-and-notify-virus-and-malware/

LOGFILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d').log";
EMAIL_MSG="Alert - a file has been flagged as infected, and moved to /quarantine";
EMAIL_FROM=$HOSTNAME;
EMAIL_TO="$ADMIN_EMAIL";
DIRTOSCAN="/home /var /tmp /etc /run /opt";
#DIRTOSCAN="/tmp";

for S in ${DIRTOSCAN}; do
 DIRSIZE=$(du -sh "$S" 2>/dev/null | cut -f1);

 echo "Starting a daily scan of "$S" directory.
 Amount of data to be scanned is "$DIRSIZE".";

 #run the scan on the directories and MOVE infected files to /quarantine
 clamscan -ri --move=/quarantine "$S" >> "$LOGFILE";

 #set permissions on all items in /quarantine to prevent access/execution
 chmod -R 400 /quarantine/*

 # get the value of "Infected lines"
 MALWARE=$(tail "$LOGFILE"|grep Infected|cut -d" " -f3);

 # if the value is not equal to zero, send an email with the log file attached
 if [ "$MALWARE" -ne "0" ];then
 #send message:
 echo "$EMAIL_MSG"|mail -a "$LOGFILE" -s "Malware Found" -r "$EMAIL_FROM" "$EMAIL_TO";
 fi
done

exit 0
