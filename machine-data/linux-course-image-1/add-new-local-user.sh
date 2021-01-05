#!/bin/bash

# Is named "add-new-local-user.sh".  (You add the word new to distinguish it from the original script.)
# Enforces that it be executed with superuser (root) privileges.  If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1.
# Provides a usage statement much like you would find in a man page if the user does not supply an account name on the command line and returns an exit status of 1.
# Uses the first argument provided on the command line as the username for the account.  Any remaining arguments on the command line will be treated as the comment for the account.
# Automatically generates a password for the new account.
# Informs the user if the account was not able to be created for some reason.  If the account is not created, the script is to return an exit status of 1.
# Displays the username, password, and host where the account was created.  This way the help desk staff can copy the output of the script in order to easily deliver the information to the new account holder.

if [[ ${UID} -ne 0 ]]
then
    echo "Must be root user to execute. Try using sudo."
    exit 1
fi

# Provide usage statement of no args are provided

if [[ ${#} -lt 1 ]]
then
    echo "Usage: ${0} USER_NAME [COMMENT]..."
    exit 1
fi

USER_NAME=$1

# by using shift, we accept the rest of the arguments using "@" as a single word as the final comment
shift
USER_COMMENT=$@

USER_PASSWORD=$( date +%s%N | sha256sum | head -c 32 )

# Create the user ( -m == --create-home )
useradd -c "${USER_COMMENT}" --create-home $USER_NAME 

USER_ADD_EXIT_STATUS=${?}
if [[ $USER_ADD_EXIT_STATUS -ne 0 ]]
then
    echo "There was an error (${USER_ADD_EXIT_STATUS}), creating the user."
    exit 1
fi

# Set the password for the user
echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd

SET_PASSWORD_EXIT_STATUS=${?}
if [[ $SET_PASSWORD_EXIT_STATUS -ne 0 ]]
then
    echo "There was an error (${SET_PASSWORD_EXIT_STATUS}), creating the password."
    exit 1
fi

# Force password change on first login
passwd -e $USER_NAME

# Echo out the final details
echo "-----SUCCESS-----"
echo "Username: ${USER_NAME}"
echo "Password: ${USER_PASSWORD}"
echo "Hostname: $(hostname)" # you can also use the variable ${HOSTNAME} instead of the command