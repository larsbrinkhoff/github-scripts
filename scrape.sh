QUERY="extension:scr+dup"
> TMP

fetch() {
  i=1
  while :; do
    echo -n "$i " 1>&2
    URL="https://github.com/search?p=$i&q=$QUERY&type=Code"
    curl "$URL" > tmp.html 2> /dev/null
    awk -F'"' '/\/blob\// && !/#/ {print $2}' < tmp.html | cut -d/ -f1-3 >> TMP
    grep 'next_page disabled' tmp.html > /dev/null && return
    i=$[$i + 1]
    sleep 10
  done
}

fetch; echo

cat TMP | while read i; do
  echo "https://github.com$i"
done | sort -u > query.csv

rm -f TMP tmp.html
