#!/bin/bash

log () {
    local MESSAGE=${@}
    echo "You called the log function with message: ${MESSAGE}, ${0}, ${1}, ${2}"
}

log "YAYER YO bro"

echo "---------------- USING GLOBAL VARIABLES WITHIN FUNCTION ----------------------"

log2 () {
    local MESSAGE=${@}
    if [[ ${VERBOSE} == 'true' ]]
    then
        echo "Verbosity yayer... ${MESSAGE}"
    else
        echo "not verbose...."
    fi
}

log2 "YAYER YO bro"

VERBOSE=true

log2 "YAYER YO bro"


echo "---------------- USING GLOBAL VARIABLES PASSED INTO FUNCTION ----------------------"

log3 () {
    local MESSAGE=${1}
    local VERBOSE=${2}
    if [[ ${VERBOSE} == 'true' ]]
    then
        echo "PASSED IN VERBOSE... ${MESSAGE}"
    else
        echo "skipping the message...."
    fi
}

log3 "global hide me"
log3 "global show me" $VERBOSE

AMOUNT=0

increment () {
    AMOUNT=$(($AMOUNT + 1))
}

echo "AMOUNT $AMOUNT"
increment
increment
echo "AMOUNT $AMOUNT"

readonly TOTAL=5

decrement () {
    TOTAL=$(($TOTAL - 1))
}

# ./luser-demo10.sh: line 59: TOTAL: readonly variable
decrement

backup_file() {
    # This funciton creates a backup of a file returns a non-zero status on error
    local FILE=${1}
    # Make sure the file exists
    if [[ -f ${FILE} ]]
    then
        local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
        echo "Backing up ${FILE} to ${BACKUP_FILE}"
        # -p preserves mode permissions and timestamp
        # a backup is a good use-case for -p in case restoration needs to preserve exactly
        cp -p $FILE $BACKUP_FILE
    else
        # The file does not exist
        return 1
    fi
}

backup_file "luser-demo10.sh"
echo "Last Command: $?"

backup_file "does-not-exist.txt"
echo "Last Command: $?"