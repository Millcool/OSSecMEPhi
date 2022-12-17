#!/bin/bash

ps -e -o pid,vsz,comm= | sort -n -k 2 | tail -n 5
