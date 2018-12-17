#!/bin/bash

if [ "${1}" != "" ]; then

  SERVER="${1}";

  STATUS=`curl -s "${SERVER}/healthcheck.html"`

  ACTION=""

# Check status
 if [ "${STATUS}" != "OK" ]; then
    sleep 10
    STATUS=`curl -s "${SERVER}/healthcheck.html"`
    if [ "${STATUS}" != "ok" ]; then
      ACTION="sendmail"
    fi
  fi

# Verify action

  if [ "${ACTION}" == "sendmail" ]; then

# Define log content
LOG="SERVICE ${SERVER} DOWN"

# Define message content
HTM="<html><body><b>STATUS ${SERVER} $(date +"%Y-%m-%d %H:%M:%S")</b><pre>${LOG}</pre></body></html>"

# Send mail
echo "${HTM}" | curl -s --insecure --user 'api:12232a1f5c172fac0aba9d77aaf3bb7d-b3780ee5-20b3d922' \
  https://api.mailgun.net/v3/sandbox1f2472d4094c404693dcc9573141ac40.mailgun.org/messages \
  -F from='No Reply <noreply@mg.dgonzalez.com>' \
  -F to='Damian <ing.damian.gonzalez@gmail.com>' \
  -F subject="SERVICE ${SERVER} DOWN" \
  -F html="<-"
  fi
fi
