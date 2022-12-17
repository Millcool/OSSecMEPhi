
#!/bin/bash

RES1=$(ps aux | cut -d' ' -f1 | grep $USER | wc -l)
echo "Процессов пользователя $USER: $RES1"

RES2=$(ps aux | cut -d' ' -f1 | grep root | wc -l)
echo "Процессов пользователя root: $RES2"
