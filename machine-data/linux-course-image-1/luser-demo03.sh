#!/bin/bash

echo "UserId: ${UID}"

echo "Username: $(id -un)"

UID_TO_TEST_FOR='0'

if [[ $UID -ne  $UID_TO_TEST_FOR ]]
then
    echo "Uh oh your user id is not ${UID_TO_TEST_FOR} it is ${UID}"
    exit 1 # a non-zero status means error ( 0 means success )
fi

USER_NAME=$(id -un)

echo "Your Username is: ${USER_NAME}"

exit 0



