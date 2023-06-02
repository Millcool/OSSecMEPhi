#!/bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S')]: $*" >&2
}

readinput() {
  local -n arr=$1
  arr+=("Справка" "Назад")
  select opt in "${arr[@]}"; do
    case $opt in
      Назад) return 0;;
      Справка) echo "Введите число, соответствующее опции из списка";;
      *)
        if [[ -z $opt ]]; then
          echo "Ошибка: введите число из списка" >&2
        else
          return $REPLY
        fi
        ;;
    esac
  done
}

if [ "$EUID" -ne 0 ]; then
  echo "Запуск произведен без прав администратора"
  exit
fi

PS3=$'\n> '
options=(
  "Управление портами"
  "Управление файлами"
  "Управление переключателями"
  "Справка"
  "Выйти"
)

while true; do
  echo "Главное меню:"
  select opt in "${options[@]}"
  do
    case $opt in
      "Управление портами")
        echo "Выберите функцию: "
        options2=(
          "Изменить существующий порт службы"
          "Добавить новый порт для службы"
          "Вывести все службы"
        )
        readinput options2
        res=$?
        [ $res == 0 ] && break
        if [ $res == 1 ]; then
          read -p "Введите имя службы: " name
          echo "Список портов данной службы: "
          semanage port -l -n | grep $name
          read -p "Введите старый порт службы: " port
          if [ -z "$port" ]; then
            echo "Ошибка: номер порта не может быть пустым"
            continue
          fi
          semanage port -d -t $name -p tcp $port
          [ $? -ne 0 ] && continue

          read -p "Введите новый порт службы: " newport
          if [ -z "$newport" ]; then
            echo "Номер порта не может быть пустым"
            continue
          fi
          semanage port -a -t $name -p tcp $newport

        elif [ $res == 2 ]; then
          read -p "Введите имя службы: " name
          if [ -z "$name" ]; then
            echo "Имя службы не может быть пустым"
            continue
          fi
          read -p "Введите новый порт для службы: " port
          if [ -z "$port" ]; then
            echo "Номер порта не может быть пустым"
            continue
          fi
          semanage port -a -t $name -p tcp $port

        else
          semanage port -l -n | cut -d" " -f1 | uniq -u | less
        fi
        ;;
      
      "Управление файлами")
        options2=(
          "Переразметка каталога"
          "Запустить полную переразметку файловой системы при перезагрузке"
          "Изменить домен файла или каталога"
        )
        readinput options2
        res=$?
        [ $res == 0 ] && break
        if [ $res == 1 ]; then
          read -p "Введите имя каталога: " path
          if [ -d "$path" ]; then
            restorecon -Rvv "$path"
          else
            echo "$path не является каталогом"
          fi

        elif [ $res == 2 ]; then
          touch /.autorelabel

        else
          read -p "Введите путь до файла или каталога: " filepath
          if [ -z "$filepath" ]; then
            err "Путь не может быть пустой"
            continue
          fi
          if [ ! -e "$filepath" ]; then
            err "Путь не существует"
            continue
          fi
          read -p "Введите новый домен: " newdomain
          semanage fcontext -a -t $newdomain "$filepath(/.*)?"
          [ $? -ne 0 ] && continue
          restorecon -Rv "$filepath"
        fi
        ;;

      "Управление переключателями")
        options2=(
          "Вывести список переключателей"
          "Изменить переключатель"
        )
        readinput options2
        res=$?
        [ $res == 0 ] && break
        if [ $res == 1 ]; then
          getsebool -a

        else
          readarray -t bools < <(getsebool -a | cut -d' ' -f1)
          readinput bools
          res=$?
          [ $res == 0 ] && break
          bool=${bools[res - 1]}
          state=$(getsebool $bool | cut -d" " -f3)
          echo "Текущее состояние: $state"
          read -p "Переключить (y/n)? " answer
          if [ "$answer" == "y" ]; then
            newstate="off"
            [ "$state" == "off" ] && newstate="on"
            setsebool -P $bool $newstate
          fi
        fi
        ;;
      
      "Справка")
        echo "Введите необходимую команду"
        ;;

      "Выйти")
        exit
        ;;

      *)
        echo "Неправильная команда $REPLY"
        ;;
    esac
  done
done
