#!/bin/bash

if [[ $1 != "" ]]
then
	du -k -d 1 "$1" | sort -n -r
else
	du -k -d 1 | sort -n -r
fi

