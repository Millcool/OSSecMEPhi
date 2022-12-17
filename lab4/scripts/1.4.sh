#!/bin/bash

echo "Good Morning, $USER"

date | cut -d' ' -f4
cal
cat ~/TODO 2> /dev/null
