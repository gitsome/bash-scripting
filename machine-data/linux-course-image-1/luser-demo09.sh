#!/bin/bash

# Demonstrate the case statement

# First show how cumbersome elif is and why case could be important

echo "----------------------- ELIF -----------------------"

if [[ $1 == "start" ]]
then
    echo "starting..."
elif [[ $1 == "stop" ]]
then
    echo "stopped"
elif [[ $1 == "status" ]]
then
    echo "running"
else
    echo "supply a valid option" >&2
fi

echo ""
echo "----------------------- CASE -----------------------"
echo ""

case $1 in 
    start)
        echo 'starting yo..'
        ;;
    stop)
        echo 'stopping yo..'
        ;;
    status)
        echo 'running yo..'
        ;;
    *) # here is the glob catch all
        echo 'supply a valid option yo..' >&2
        ;;
esac

echo ""
echo "----------------------- OR USING PIPE -----------------------"
echo ""

# PIPE gives you options for OR patterns
# This also shows an alternate syntax for one liners

case $1 in 
    start) echo 'starting yoseph..';;
    stop) echo 'stopping yoseph..' ;;
    status|state) # here is where the OR is via a pipe
        echo 'running yoseph..'
        ;;
    *) echo 'supply a valid option yoseph..' >&2;;
esac