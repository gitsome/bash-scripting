#!/bin/bash

echo "Parameter1: ${1}"
echo "Parameter1: ${2}"
echo "Parameter1: ${3}"

echo ""

X=0

while [[ $X -lt 5 ]] 
do
    echo "yayer ${X}"
    X=$((X+1))
done

echo ""


while [[ ${#} -gt 0 ]] 
do
    echo "The number of parameters: ${#}"
    echo "Parameter1: ${1}"
    echo "Parameter1: ${2}"
    echo "Parameter1: ${3}"
    echo ""
    shift
done