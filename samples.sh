#!/bin/bash

folder=$2
query=${1// /+}
session_id=$3
option=""
if [ "$#" -eq 4 ]; then
  if [ "$4" == "new" ]; then
    option="s=indexed&o=desc&"
  elif [ "$4" == "old" ]; then
    option="s=indexed&o=asc&"
  fi
fi

tmp_html="$folder.html"
tmp_txt="$folder.txt"
> $tmp_txt
> $tmp_html

progress_bar() {
  progress=$1
  total=$2
  nb_equals=$[$progress * 50 / $total]
  echo -n '['
  j=0
  for ((;j<nb_equals;j++)); do
    echo -n '='
  done
  echo -n '>'
  for ((;j<50;j++)); do
    echo -n " "
  done
  echo -n '] '
  pourcentage=$[$progress * 100 / $total]
  echo -ne "$pourcentage% ($progress)\r"
}

fetch_page() {
  page=$1
  URL="https://github.com/search?${option}p=$page&q=$query&type=Code"
  wget --header "Cookie: user_session=${session_id}" -O $tmp_html "$URL" 2> /dev/null
  awk -F'"' '/\/blob\// && !/#/ {print $2}' < $tmp_html >> $tmp_txt
  grep 'next_page' $tmp_html > /dev/null || stop="1"
  grep 'next_page disabled' $tmp_html > /dev/null && stop="1"
}

fetch() {
  stop="0"
  fetch_page 1
  total=`grep -oP '(?<=>)[0-9]+(?=</a>\s*<a class="next_page")' $tmp_html`
  i=2
  while [ $stop -eq 0 ] ; do
    progress_bar $i $total
    sleep 10
    fetch_page $i
    i=$[$i + 1]
  done
}

echo 'Fetching search results:'
fetch
echo

total=`wc -l < $tmp_txt`

i=1
echo 'Downloading files:'
cat $tmp_txt | while read line; do
  progress_bar $i $total
  file="$folder/"`echo $line | cut -d/ -f1-3,6-`
  mkdir -p $(dirname $file)
  url="https://raw.githubusercontent.com`echo $line | sed 's/\/blob\//\//'`"
  curl "$url" 2> /dev/null > $file
  i=$[$i + 1]
done
echo

rm -f $tmp_txt $tmp_html
