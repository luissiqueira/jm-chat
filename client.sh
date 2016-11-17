#!/bin/bash

trap stop_client INT
function stop_client {
  echo
  echo "Stopping jm-chat client..."
  echo "UUID: $uuid"
  ps | grep -v grep | grep tail | grep "$uuid" | cut -f1 -d "t" | xargs -n 1 kill
  exit 0
}

uuid=$(uuidgen)
username=$uuid
users_dir=/tmp/jm-chat/users
my_messages_file=$users_dir/$uuid
all_messages_file=.jm-chat-history

mkdir -p $users_dir
touch $my_messages_file
touch $all_messages_file

function connect {
  tail -n 0 -q -f $my_messages_file&
  echo "Usuário conectado!"
  echo
}

function handle_entry {
  if [ "${1::1}" == "/" ]
  then
    case $1 in
      "/help"*)
        show_help
      ;;
      "/username"*)
        candidate_username=${@#"/username"}
        if [ ! -z "$candidate_username" ]
        then
          send_system_message "[$username] alterou o nome para [$candidate_username]."
          username=$candidate_username
        fi
      ;;
      *)
        log_event "[$username] tentou usar o comando \"$@\"."
        echo "Comando \"$@\" não implementado!"
      ;;
    esac

    echo
  else
    send_message $@
  fi
}

function log_event {
  echo "$@" >> $all_messages_file
}

function format_text_with_emoticons {
  # msg=$@
  # echo "${msg//<3/❤}"
  echo $@
}

function send_system_message {
  for i in `ls $users_dir`
  do
    format_text_with_emoticons $@ >> $users_dir/$i
  done
  log_event $@
}

function send_message {
  for i in `ls $users_dir | grep -v $uuid`
  do
    echo "[$username] disse: $@" >> $users_dir/$i
  done
  log_event "[$username] disse: $@"

  tl=`wc -l < $all_messages_file`
  if [ `expr $tl` -gt 100 ]
  then
    timestamp=`date +%s`
    mv $all_messages_file "${all_messages_file}_${timestamp}"
  fi
}

function show_help {
  cat help.txt
}

function setup_username {
  echo -n "Informe o nome que deseja utilizar: "
  read candidate_username
  while [ -z "$candidate_username" ]
  do
    echo -n "Informe o nome que deseja utilizar: "
    read candidate_username
  done

  log_event "[$username] alterou o nome para [$candidate_username]."
  username=$candidate_username
}

setup_username
connect
show_help
send_system_message "[$username] entrou no chat."

while :
do
  echo -n "> "
  read input
  if [ ! -z "$input" ]
  then
    handle_entry $input
  fi
done