#!/bin/sh

NUM_PROC=`ps -ef | grep "application_name" | grep -v grep | wc -l`
STD_OUT_FILE=./stdout
STD_ERR_FILE=./stderr
RESTART_LOG_FILE=./restart.log
MAIL_SUBJECT="restarting application"
MAIL_ATTACHMENT=./error_mail.txt
FROM_ADD="admin_email"
TO_ADD="dev_email"

if [ "$NUM_PROC" -eq 0 ]
then
   echo "" > $MAIL_ATTACHMENT
   if [[ -f $STD_OUT_FILE && -f $STD_ERR_FILE ]]
   then
      mailx -a $STD_OUT_FILE -a $STD_ERR_FILE -r $FROM_ADD -s "`hostname`:$MAIL_SUBJECT" $TO_ADD < $MAIL_ATTACHMENT
   else
      mailx -r $FROM_ADD -s "`hostname`:$MAIL_SUBJECT" $TO_ADD < $MAIL_ATTACHMENT
   fi
   #restart application here
   echo "Restarted application due to errors on `date`" >> $RESTART_LOG_FILE
   echo "$MAIL_SUBJECT" >> $RESTART_LOG_FILE
   echo "-------------" >> $RESTART_LOG_FILE
fi
