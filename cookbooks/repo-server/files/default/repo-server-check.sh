#!/bin/bash

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

echo -e "\nrepo-server-check start\n"

word="nginx proccess"
command="ps -ef | grep nginx | grep -v grep | wc -l"
check

word="nginx status"
command="service nginx status | grep running | wc -l"
check

word="https port"
command="netstat -tunl | grep :443 | wc -l"
check

word="https responce"
command="curl -k 'https://localhost/check.html' --max-time 5 2> /dev/null | grep 'html-check OK' | wc -l"
check

word="packages responce"
command="curl -k 'https://localhost/packages/check.html' --max-time 5 2> /dev/null | grep 'html-check OK' | wc -l"
check

echo "Check completed!"
echo "Final result ALL:${test_count} success:${success_count} fail:${error_count}"