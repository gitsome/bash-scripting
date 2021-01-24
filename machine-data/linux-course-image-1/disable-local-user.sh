#!/bin/bash

# Enforces that it be executed with superuser (root) privileges.  If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1.  All messages associated with this event will be displayed on standard error.
# Provides a usage statement much like you would find in a man page if the user does not supply an account name on the command line and returns an exit status of 1.  All messages associated with this event will be displayed on standard error.
# Disables (expires/locks) accounts by default.
# Allows the user to specify the following options:
#   -d Deletes accounts instead of disabling them.
#   -r Removes the home directory associated with the account(s).
#   -a Creates an archive of the home directory associated with the accounts(s) and stores the archive in the /archives directory.  (NOTE: /archives is not a directory that exists by default on a Linux system.  The script will need to create this directory if it does not exist.)
# Any other option will cause the script to display a usage statement and exit with an exit status of 1.
# Accepts a list of usernames as arguments.  At least one username is required or the script will display a usage statement much like you would find in a man page and return an exit status of 1.  All messages associated with this event will be displayed on standard error.
# Refuses to disable or delete any accounts that have a UID less than 1,000.
# Only system accounts should be modified by system administrators.  Only allow the help desk team to change user accounts.
# Informs the user if the account was not able to be disabled, deleted, or archived for some reason.
# Displays the username and any actions performed against the account.

readonly USER_ARCHIVE_DIR="/user-archives"

if [[ $UID -ne 0 ]]; then
    echo "Sorry buddy, you need to be root" >&2
    exit 1
fi

DELETE_USER='false'
REMOVE_HOME_DIRECTORY='false'
ARCHIVE_HOME_DIRECTORY='false'

usage () {
    echo ""
    echo "--------------------------------------------------------------------"
    echo ""
    echo "Usage: ${0} [-dra] USERNAMES"
    echo ""
    echo "Disable a user account"
    echo " -d           Delete the account."
    echo " -r           Remove home directory."
    echo " -a           Archive their home directory into USER_ARCHIVE_DIR"
    echo ""
    exit 1
}

function join_by { 
    local d=$1; 
    shift; 
    local f=$1; 
    shift; 
    printf %s "$f" "${@/#/$d}"; 
}

while getopts dra OPTION
do 
    case ${OPTION} in 
        d)
            DELETE_USER='true';;
        r)
            REMOVE_HOME_DIRECTORY='true';;
        a)
            ARCHIVE_HOME_DIRECTORY='true';;
        ?)
            echo 'Invalid options.' >&2
            usage;;
    esac
done

# Update positional arguments based on consumed getopts to only user names
shift $(( OPTIND - 1 ))

# Exit if no params provided
if [[ ${#} -eq 0 ]]
then
    echo 'Invalid options.' >&2
    usage
fi

# Loop through provided user names
for USER_NAME in ${@}; do

    USER_ACTIONS=()
    USER_ID=$(id -u ${USER_NAME})
    
    if [[ $USER_ID -lt 1000 ]]; then
        echo "Cannot delete user ${USER_NAME} with UID < 1000." >&2
    else

        if [[ ${ARCHIVE_HOME_DIRECTORY} == 'true' ]]; then

            mkdir -p ${USER_ARCHIVE_DIR}

            ARCHIVE_FILE="${USER_ARCHIVE_DIR}/${USER_NAME}.${USER_ID}.trg"

            tar -zc -f ${ARCHIVE_FILE} "/home/${USER_NAME}" &> /dev/null
            ARCHIVE_EXIT_CODE=${?}
            
            if [[ ${ARCHIVE_EXIT_CODE} -ne 0 ]]; then
                echo "Unable to archive home directory for user ${USER_NAME}" >&2
            else
                USER_ACTIONS+=("HOME_DIRECTORY_ARCHIVED")
            fi 
        fi

        if [[ ${DELETE_USER} == 'true' ]]; then
            

            if [[ ${REMOVE_HOME_DIRECTORY} == 'true' ]]; then
                
                # delete the user account and DELETE their home directory
                userdel -r ${USER_NAME}
                USER_DELETE_REMOVE_HOME_EXIT_CODE=${?}

                if [[ ${USER_DELETE_REMOVE_HOME_EXIT_CODE} -eq 0 ]]; then
                    USER_ACTIONS+=("DELETED")
                    USER_ACTIONS+=("HOME_DIRECTORY_REMOVED")
                else
                    echo "Error trying to delete and remove home direcotry for user ${USER_NAME}" >&2
                fi

            else

                # delete the user account but KEEP their home directory
                userdel ${USER_NAME}
                USER_DELETE_EXIT_CODE=${?}

                if [[ ${USER_DELETE_EXIT_CODE} -eq 0 ]]; then
                    USER_ACTIONS+=("DELETED")
                else
                    echo "Error trying to delete account for ${USER_NAME}" >&2
                fi
            fi

        else

            # expire the account
            chage -E 0 $USER_NAME
            USER_EXPIRED_EXIT_CODE=${?}

            if [[ ${USER_EXPIRED_EXIT_CODE} -eq 0 ]]; then
                USER_ACTIONS+=("DISABLED")
            else
                echo "Error trying to disable account for ${USER_NAME}"
            fi
        fi

        # FINALLY SUMMARIZE THE SUCCESSFUL ACTIONS
        if [[ ${#USER_ACTIONS[@]} -gt 0 ]]; then
            echo "Actions for user: ${USER_NAME} - $(join_by , ${USER_ACTIONS[@]})"
        fi

    fi
done

exit 0