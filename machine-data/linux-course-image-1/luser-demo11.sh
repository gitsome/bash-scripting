#!/bin/bash

LENGTH=48
VERBOSE='false'
USE_SPECIAL_CHARACTER='false'

usage () {
    echo ""
    echo "--------------------------------------------------------------------"
    echo ""
    echo "Usage: ${0} [-vs] [-l LENGTH]"
    echo ""
    echo "Generate a random password"
    echo " -l   LENGTH  Specify the password length ( defaults to ${LENGTH} )."
    echo " -s           Append a special character to the password."
    echo " -v           Increase Verbosity."
    echo ""
    exit 1
}

notify () {
    local MESSAGE="${@}"
    if [[ $VERBOSE = "true" ]]
    then
        echo $MESSAGE
    fi
}

while getopts vl:s OPTION
do 
    case ${OPTION} in 
        v)
            VERBOSE='true'
            echo 'Verbose mode on.';;
        l)
            LENGTH="${OPTARG}";;
        s)
            USE_SPECIAL_CHARACTER='true';;
        ?)
            echo 'Invalid options.' >&2
            usage;;
    esac
done

# NOW do a check for any additional values after the params consumed by the getopts
# this is done by looking at the final value of OPTIND after the getopts loop
# some commands want a final string ( non param indicated ) but this one should choke on it
shift $(( OPTIND - 1 ))

if [[ ${#} -gt 0 ]]
then
    echo 'Invalid options.' >&2
    usage
fi

# Otherwise we are good to continue
notify "Generating password with length ${LENGTH}."

# Generate the password
PASSWORD=$( date +%s%N | sha256sum | head -c$LENGTH )

# Create the additional special character
if [[ ${USE_SPECIAL_CHARACTER} == "true" ]]
then
    notify "Adding special character..."
    SPECIAL_CHARACTER=$(echo '!@#$%^&*()-+=)' | fold -w1 | shuf | head -c1)
    PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

echo $PASSWORD
exit 0




