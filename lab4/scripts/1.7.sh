#!/bin/bash

date | cut -d' ' -f2,3,6
date | cut -d' ' -f4
cat /etc/passwd | cut -d: -f1
uptime
