#!/bin/bash

trap stop_server INT
function stop_server {
  echo
  echo "Stopping jm-chat server..."
  send_system_message "Server is shutdown."
  ps | grep -v grep | grep tail | cut -f1 -d "t" | xargs -n 1 kill
  ps | grep -v grep | grep "/bin/bash ./client.sh" | cut -f1 -d "t" | xargs -n 1 kill
  exit 0
}

function send_system_message {
  users_dir=/tmp/jm-chat/users
  for i in `ls $users_dir`
  do
    echo $@ >> $users_dir/$i
  done
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