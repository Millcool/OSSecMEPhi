#!/bin/bash

touch /tmp/zeros /tmp/nozeros
cat ~/bash.txt | while read line
do
	if [[ $line == *"000000"* ]]; then
		echo "$line" >> /tmp/zeros
	else
		echo "$line" >> /tmp/nozeros
	fi
done

head /tmp/zeros
echo '/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/'
tail /tmp/zeros
echo -------------------------------------------------------
head /tmp/zeros
echo '/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/'
tail /tmp/zeros
