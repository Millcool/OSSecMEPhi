#!/bin/bash

echo "Домашний каталог пользователя"
eval echo "~$different_user"

echo "Содержит обычных файлов:"
find ~ -maxdepth 1 -type f -not -name ".*" | wc -l

echo "Сожержит скрытых файлов:"
find ~ -maxdepth 1 -type f -name ".*" | wc -l
