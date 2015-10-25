#!/bin/bash

folder=$2
query=${1// /+}
tmp_html="$folder.html"
tmp_txt="$folder.txt"
> TMP

fetch() {
  i=1
  while :; do
    echo -n "$i " 1>&2
    URL="https://github.com/search?p=$i&q=$query&type=Code"
    curl "$URL" > $tmp_html 2> /dev/null
    awk -F'"' '/\/blob\// && !/#/ {print $2}' < $tmp_html >> $tmp_txt
    grep 'next_page' $tmp_html > /dev/null || return
    grep 'next_page disabled' $tmp_html > /dev/null && return
    i=$[$i + 1]
    sleep 10
  done
}

fetch; echo

cat $tmp_txt | while read i; do
  file="$folder/"`echo $i | cut -d/ -f1-3,6-`
  mkdir -p $(dirname $file)
  url="https://raw.githubusercontent.com`echo $i | sed 's/\/blob\//\//'`"
  curl "$url" 2> /dev/null > $file
done

rm -f $tmp_txt $tmp_html
