#!/bin/bash

echo '*** Keybase Messaging Tool ***'

LIST=($(keybase list-following))
ID=$(keybase status | awk '/Default user:/ {print $3}')
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

echo "Your Message (Ctrl-D to end): "
input=$(cat)

echo $input | keybase $1 encrypt $KBUSER > /keybase/private/$ID,$KBUSER/$(perl -e 'print(time());')
