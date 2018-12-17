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
echo "${HTM}" | curl -s --insecure --user $API \
  $DOMAIN \
  -F from='No Reply <noreply@mg.dgonzalez.com>' \
  -F to="Damian <$EMAIL>" \
  -F subject="SERVICE ${SERVER} DOWN" \
  -F html="<-"
  fi
fi
