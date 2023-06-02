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
	"Поиск событий аудита"
	"Отчёты аудита"
	"Настройка подсистемы аудита"
	"Справка"
	"Выйти"
)

select opt in "${options[@]}"
do
	case $opt in
	"Поиск событий аудита")
		read -p "Пожалуйста, введите тип события (если пусто, то ALL): " eventtype
		if [ "$eventtype" == "" ]; then
			eventtype=ALL
		fi
		read -p "Введите UID пользователя (может быть пустым): " userid
		read -p "Введите строку поиска: " searchstring
		[ "$searchstring" == "" ] && searchstring="="
		[ "$userid" == "" ] && ausearch -m $eventtype | grep $searchstring -B 2 && continue
		ausearch -m $eventtype -ui $userid | grep $searchstring -B 2
		;;
    "Отчёты аудита")
  echo "Пожалуйста, выберите интересующую информацию: "
  options2=("Отчёт о входе пользователей в систему" "Отчёт о нарушениях")
  readinput options2
  res=$?
  [ $res == 0 ] && continue
  if [ $res == 1 ]; then
    rep="-au -ts"
    echo "Сгенерирован отчёт (файлы с префиксом auth) о входе пользователей за 1 день, неделю, месяц, год"
    aureport $rep today >auth_day
    aureport $rep this-week >auth_week
    aureport $rep this-month >auth_month
    aureport $rep this-year >auth_year
  else
    fail="--failed --user"
    echo "Сгенерирован отчёт (файлы с префиксом fail) о нарушениях за 1 день, неделю, месяц, год."
    aureport $fail -ts today >fail_day
    aureport $fail -ts this-week >fail_week
    aureport $fail -ts this-month >fail_month
    aureport $fail -ts this-year >fail_year
  fi
  ;;
"Настройка подсистемы аудита")
  echo "Пожалуйста, выберите опцию: "
  options2=("Добавить каталог или файл в список наблюдения" "Удалить из списка наблюдения" "Отчёт по наблюдению")
  readinput options2
  res=$?
  [ $res == 0 ] && continue
  if [ $res == 1 ]; then
    read -p "Пожалуйста, введите путь до файла или каталога: " filepath
    if [ "$filepath" == "" ]; then
      err "Путь не может быть пустой"
      continue
    fi
    if [ ! -e ]; then
      err "Пути не существует"
      continue
    elif [ -d $filepath ]; then
      auditctl -a exit,always -F dir=$filepath -F perm=warx
    else
      auditctl -w $filepath -p warx
    fi
  elif [ $res == 2 ]; then
    echo "Пожалуйста, Выберите путь"
    readarray -t paths < <(auditctl -l | cut -d " " -f2)
    readinput paths
    res=$?
    [ $res == 0 ] && continue
    path=${paths[res - 1]}
    auditctl -W $path
  else
    echo "Пожалуйста, выберите путь"
    readarray -t paths < <(auditctl -l | cut -d " " -f2)
    readinput paths
    res=$?
    [ $res == 0 ] && continue
    path=${paths[res - 1]}
    res=$(aureport --file | grep $path)
    [ "$res" == "" ] && res="Нет событий"
    echo "${res}"
  fi
  ;;
"Справка")
    echo "Пожалуйста, введите команду !"
    ;;
"Выйти")
      break
      ;;
  *) echo "Неправильная команда, пожалуйста попробуйте ещё раз" ;;
  esac
done
