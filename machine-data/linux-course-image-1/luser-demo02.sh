#!/bin/bash

# Display the UID and the username of the user executing the script.
# Display if the user is the root user or not.

echo "UID: ${UID}"

USER_NAME=$(id -un)

echo $USER_NAME

if [[ $UID -eq 0 ]]
then 
    echo 'You are root.'
else
    echo 'You are not root.'
fi