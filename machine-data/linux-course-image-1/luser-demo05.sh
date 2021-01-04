#!/bin/bash

# password
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "Random Password: $PASSWORD"

# maybe better using the date
PASSWORD_DATE=$(date +%s)
echo "Date Based Password: $PASSWORD_DATE"

# cryptography!
PASSWORD_HASH=$(date +%s%N | sha256sum | head -c32)
echo "Better password: ${PASSWORD_HASH}"

# get a special character
SPECIAL="@#$%^&"
RANDOM_SPECIAL=$(echo $SPECIAL | fold -w1 | shuf | head -c1 )

# good password with a special character
echo "Best password: ${PASSWORD_HASH}${RANDOM_SPECIAL}"