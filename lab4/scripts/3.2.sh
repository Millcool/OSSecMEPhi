#!/bin/bash

3.1.sh "$@"

for i in [$@]
do
	3.1.sh $i
done
