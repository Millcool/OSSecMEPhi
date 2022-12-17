md5sum *.txt | sort -k1 | uniq -w32 -d -c | awk '{ print $1, $3;}'
