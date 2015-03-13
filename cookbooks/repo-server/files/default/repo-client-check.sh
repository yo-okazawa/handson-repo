#!/bin/bash
echo $1
if [[ $1 =~ ^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$ ]]; then
  ipaddress=$1
else
  echo -e "\e[31m[arg check fail]\e[m please input ipaddress"
  echo "like [sh repo-client-check.sh 192.168.*.*]"
  exit 0
fi

test_count=0
success_count=0
error_count=0

function check ()
{
  test_count=`expr $test_count + 1`
  echo "[${test_count}] ${word} check (${command})"
  count=`eval ${command}`
  if [ $count = 0 ]; then
    echo -e "\e[31m[NG]\e[m ${word} check fail result:${count}\n"
    error_count=`expr $error_count + 1`
  else
    echo -e "\e[32m[OK]\e[m ${word} check success result:${count}\n"
    success_count=`expr $success_count + 1`
  fi
}

echo -e "\nrepo-client-check start\n"

word="https responce"
command="curl -k 'https://${ipaddress}/check.html' --max-time 5 2> /dev/null | grep 'html-check OK' | wc -l"
check

word="packages responce"
command="curl -k 'https://${ipaddress}/packages/check.html' --max-time 5 2> /dev/null | grep 'html-check OK' | wc -l"
check

echo "Check completed!"
echo "Final result ALL:${test_count} success:${success_count} fail:${error_count}"
