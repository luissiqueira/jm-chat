#!/bin/bash

users_dir=/tmp/jm-chat/users
mkdir -p $users_dir

trap stop_server INT
function stop_server {
  echo
  echo "Stopping jm-chat server..."
  ps | grep -v grep | grep tail | cut -f1 -d" " | xargs -n 1 kill
  ps | grep -v grep | grep "/bin/bash ./client.sh" | cut -f1 -d" " | xargs -n 1 kill
  exit 0
}

start_command="ncat -vvv -k -l -p 8080 -c ./client.sh"

if [ "$(ps | grep -v grep | grep -c "$start_command")" -lt "1" ]
then
  echo "Starting jm-chat server..."
  $start_command
else
  echo "jm-chat server already running."
fi