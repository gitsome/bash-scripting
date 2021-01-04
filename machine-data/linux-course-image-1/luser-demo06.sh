#!/bin/bash

# This script should output a random password for each user provided

echo "The command used: ${0}"

echo "You used the $(dirname ${0}) as the path to the $(basename ${0}) script"

echo "You provided ${#} argument(s)"

echo "Here are the arguments as a single line: ${*}"

if [[ $# -lt 1 ]]
then
    echo "You have to provide a username..."
    exit 1
fi

for USER_NAME in ${@}
do
    PASSWORD=$(date +%s%N | sha256sum | head -c32 )
    echo "${USER_NAME} : ${PASSWORD}"
done