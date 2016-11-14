#!/bin/bash

uuid=$(uuidgen)
username=$uuid
users_dir=/tmp/jm-chat/users
my_messages_file=$users_dir/$uuid
all_messages_file=.jm-chat-history

version="0.1"
site_url="https://github.com/luissiqueira/jm-chat"

trap stop_server INT
function stop_server() {
  echo
  echo "Stopping jm-chat server..."
  ps | grep -v grep | grep tail | cut -f1 -d "t" | xargs -n 1 kill
  rm $my_messages_file
  exit 0
}

# check if a process already running
if [ "$(ps -ef | grep -v grep | grep -c "ncat.*$(basename $0)")" -lt "1" ]
then
  echo "Starting jm-chat server..."
  while :
  do
    timestamp=`date +%s`
    ncat -vvv -k -l -p 8080 -c $0
  done
else
  [[ ! $(tty) ]] && exit 1
fi

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
          log_event "[$username] alterou o nome para [$candidate_username]."
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

function send_system_message {
  for i in `ls $users_dir`
  do
    echo "$@" >> $users_dir/$i
  done
}

function send_message {
  for i in `ls $users_dir | grep -v $uuid`
  do
    echo "[$username] disse: $@" >> $users_dir/$i
  done
  echo "[$username] disse: $@" >> $all_messages_file

  tl=`wc -l < $all_messages_file`
  if [ `expr $tl` -gt 100 ]
  then
    timestamp=`date +%s`
    mv $all_messages_file "${all_messages_file}_${timestamp}"
  fi
}

function show_help {
  echo "jm-chat $version ($site_url)"
  echo
  echo "Opções de uso:"
  echo "/username USERNAME      Altera o nome de exibição para o USERNAME escolhido."
  echo "/help                   Exibe essa mensagem."
  echo
}

connect
show_help
send_system_message "[$username] entrou no chat."

while :
do
  read input
  if [ ! -z "$input" ]
  then
    handle_entry $input
  fi
done