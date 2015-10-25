#!/bin/bash

folder=$2
query=${1// /+}
option=""
if [ "$#" -eq 3 ]; then
  if [ "$3" == "new" ]; then
    option="s=indexed&o=desc&"
  elif [ "$3" == "old" ]; then
    option="s=indexed&o=asc&"
  fi
fi

tmp_html="$folder.html"
tmp_txt="$folder.txt"
> $tmp_txt
> $tmp_html

progress_bar() {
  i=$1
  total=$2
  nb=$[$i * 50 / $total]
  echo -n '['
  for ((j=0;j<nb;j++)); do
    echo -n '='
  done
  echo -n '>'
  nb=$[49 - $nb]
  for ((j=0;j<nb;j++)); do
    echo -n " "
  done
  echo -n '] '
  pourcentage=$[$i * 100 / $total]
  echo -ne "$pourcentage%\r"
}

fetch() {
  URL="https://github.com/search?${option}p=1&q=$query&type=Code"
  curl "$URL" > $tmp_html 2> /dev/null
  total=`grep -oP '(?<=>)[0-9]+(?=</a>\s*<a class="next_page")' $tmp_html`
  i=1
  while :; do
    progress_bar $i $total
    URL="https://github.com/search?${option}p=$i&q=$query&type=Code"
    curl "$URL" > $tmp_html 2> /dev/null
    awk -F'"' '/\/blob\// && !/#/ {print $2}' < $tmp_html >> $tmp_txt
    grep 'next_page' $tmp_html > /dev/null || return
    grep 'next_page disabled' $tmp_html > /dev/null && return
    i=$[$i + 1]
    sleep 10
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
