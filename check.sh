#!/bin/bash

matching_files=$(find /var/www/html/ -type f -name "index.html")

if [ -z "$matching_files" ]; then
   exit 1
fi

check_port=$(netstat -tlpn4 | grep ":80")

if [ -z "$check_port" ]; then
   exit 1
fi

echo $?
