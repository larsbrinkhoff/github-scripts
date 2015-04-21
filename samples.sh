QUERY="extension:scr+dup+swap"
> TMP

fetch() {
  i=1
  while :; do
    echo -n "$i " 1>&2
    URL="https://github.com/search?p=$i&q=$QUERY&type=Code"
    curl "$URL" > tmp.html 2> /dev/null
    awk -F'"' '/\/blob\// && !/#/ {print $2}' < tmp.html >> TMP
    grep 'next_page' tmp.html > /dev/null || return
    grep 'next_page disabled' tmp.html > /dev/null && return
    i=$[$i + 1]
    sleep 10
  done
}

fetch; echo

cat TMP | while read i; do
  file=samples/`echo $i | cut -d/ -f1-3,6-`
  mkdir -p $(dirname $file)
  curl "https://github.com$i" 2> /dev/null > $file
done

rm -f TMP tmp.html
