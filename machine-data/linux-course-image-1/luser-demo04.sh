#!/bin/bash

# This script must be run as root user as root user is the only one who can add users and deal with passwords

# Ask for the user name ( 8 characters or less by convention )
read -p 'Enter the username to create: ' USER_NAME
echo $USER_NAME

# Ask for the real name
read -p 'Enter the name of the person who this account is for: ' USER_COMMENT
echo $USER_COMMENT

# Ask for the password
read -p 'Enter an initial password for this user: ' USER_PASSWORD

# Create the user
useradd -c "${USER_COMMENT}" --create-home $USER_NAME 

# Set the password for the user
echo ${USER_PASSWORD} | passwd –-STDIN ${USER_NAME}

# Force password change on first login
passwd -e $USER_NAME

# You can test this by switching to the user and seeing if the password gets reset
# su <username>
# entering password '<your password>'

# You can see all the users info and the comment
# cat /etc/passwd
