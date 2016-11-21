#!/bin/bash

users_dir=/tmp/jm-chat/users
mkdir -p $users_dir

trap stop_server INT
function stop_server {
  echo
  echo "Stopping jm-chat server..."
  exit 0
}

function send_system_message {
  for i in `ls $users_dir`
  do
    echo "$users_dir/$i"
    echo $@ >> $users_dir/$i
  done
}

start_command="ncat -vvv -k -l -p 8080 -c ./client.sh"

if [ "$(ps | grep -v grep | grep -c "$start_command")" -lt "1" ]
then
  echo "Starting jm-chat server..."#
  while :
  do
    $start_command
  done
else
  echo "jm-chat server already running."
fi