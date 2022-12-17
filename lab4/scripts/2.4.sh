#!/bin/bash

while read line
do
	if [[ $line == *"bin"* ]]; then
		echo $line >&2
	fi
done
