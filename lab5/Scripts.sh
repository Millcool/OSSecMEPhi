#!/bin/bash

ps -eo euid,ruid,comm | awk '{if ($1 != $2) print $3}'
