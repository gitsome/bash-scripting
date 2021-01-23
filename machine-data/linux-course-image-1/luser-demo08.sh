#!/bin/bash

FILE=/tmp/data

echo "yayer" > $FILE

# redirect STDIN to a program, using FD 0 ( File Descriptor 0 )
read LINE 0< ${FILE}
echo "The variable LINE: ${LINE}"

# Redirect STDOUT to a file using FD 1, overwriting the file
head -n3 /etc/passwd 1> ${FILE}
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect STDIN to STDIN for read
wc -l < "booyah you bro"
echo "the results of STDOUT into STDIN ${X}"