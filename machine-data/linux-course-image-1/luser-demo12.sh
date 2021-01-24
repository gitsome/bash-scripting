#!/bin/bash

if [[ $UID -ne 0 ]]; then
    echo "Sorry buddy, you need to be root" >&2
    exit 1
fi

USER=${1}

userdel "${USER}"

if [[ ${?} -ne 0 ]]; then
    echo "The account ${USER} was NOT deleted." >&2
    exit 1
fi

echo "Account ${USER} was deleted."
exit 0