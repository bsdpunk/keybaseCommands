#!/bin/bash
KB=$(keybase id 3>&1 1>&2- 2>&3- | grep -o 'Identifying .*$' | sed 's/Identifying \(.*\)/\1/' | gsed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" )
printf 'What user is this to?: '
read -r KBUSER
echo ''
echo "Your Message(End with Ctrl-D): "
input=$(cat)

echo $input | keybase $1 encrypt $KBUSER > /keybase/private/$KB,$KBUSER/$(perl -e 'print(time());')
