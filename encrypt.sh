#!/bin/bash

function usage {
	cat <<- EOF

		If you plan to message a user that you are following, there is no need to specify a recipient at runtime. 

		SYNTAX
			encrypt.sh [ USER ]

	EOF
}

function user_selection {
  LIST=($(keybase list-following))
  TOTAL=${#LIST[@]}
  COUNT=1
  USER=0

  for following in ${LIST[@]}; do
    echo "($COUNT) $following"
    ((COUNT+=1))
  done

  until [[ "$USER" -ge 1 && "$USER" -le "$TOTAL" ]]; do
    echo 'What user are we conversing with today?'
    read -p '> ' USER
  done

  KBUSER=${LIST[(($USER-1))]}
}

ID=$(keybase status | awk '/Default user:/ {print $3}')

echo '*** Keybase Messaging Tool ***'
usage

if [ $# -eq 0 ]; then
  user_selection
else
  keybase id $1 > /dev/null 2>&1
  if [ "$?" -ne "0" ]; then
    echo "User $1 does not exist."
    exit 1
  else
    KBUSER=$1
  fi
fi

echo "Your Message (Ctrl-D to end): "
input=$(cat)

keybase encrypt -m "$input" $KBUSER > /keybase/private/$ID,$KBUSER/$(date +%s)
