#!/bin/bash

trap stop_server INT
function stop_server() {
  echo
  echo "Stopping jm-chat server..."
  ps | grep -v grep | grep tail | cut -f1 -d "t" | xargs -n 1 kill
  exit 0
}

start_command="ncat -vvv -k -l -p 8080 -c ./client.sh"

if [ "$(ps | grep -v grep | grep -c "$start_command")" -lt "1" ]
then
  echo "Starting jm-chat server..."#
  while :
  do
    timestamp=`date +%s`
    $start_command
  done
else
  echo "jm-chat server already running."
fi