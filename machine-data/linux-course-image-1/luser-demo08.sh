#!/bin/bash

FILE=/tmp/data

echo "yayer" > $FILE

# redirect STDIN to a program, using FD 0
read LINE 0< ${FILE}
echo "The variable LINE: ${LINE}"

# Redirect STDOUT to a file using FD 1, overwriting the file
head -n3 /etc/passwd 1> ${FILE}
echo "Contents of ${FILE}-------------->"
cat ${FILE}
