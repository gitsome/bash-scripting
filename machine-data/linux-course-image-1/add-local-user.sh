#!/bin/bash

# Is named "add-local-user.sh".
# Enforces that it be executed with superuser (root) privileges.  If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1.
# Prompts the person who executed the script to enter the username (login), the name for person who will be using the account, and the initial password for the account.
# Creates a new user on the local system with the input provided by the user.
# Informs the user if the account was not able to be created for some reason.  If the account is not created, the script is to return an exit status of 1.
# Displays the username, password, and host where the account was created.  This way the help desk staff can copy the output of the script in order to easily deliver the information to the new account holder.

if [[ ${UID} -ne 0 ]]
then
    echo "Must be root user to execute. Try using sudo."
    exit 1
fi

read -p 'Username: ' USER_NAME
read -p 'User Comment: ' USER_COMMENT
read -p 'Initial Password: ' USER_PASSWORD

# Create the user
useradd -c "${USER_COMMENT}" --create-home $USER_NAME 

if [[ ${?} -ne 0 ]]
then
    echo "There was an error (${?}), creating the user."
    exit 1
fi

# Set the password for the user
echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd

# Force password change on first login
passwd -e $USER_NAME

# Echo out the final details
echo "-----SUCCESS-----"
echo "Username: ${USER_NAME}"
echo "Password: ${USER_PASSWORD}"
echo "Hostname: $(hostname)" # you can also use the variable ${HOSTNAME} instead of the command

# might as well be explicit about the exit value
exit 0