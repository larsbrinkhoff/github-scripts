repos="
https://github.com/danmey/FourK
"

: "
https://github.com/keithcausey/GreenArrays
https://github.com/blackpit73/arrayForth
"

dir=git-temp
rm -rf $dir
for i in $repos; do
  printf %-45s $i
  git clone $i $dir > /dev/null 2>&1
  sh run.sh $dir | awk 'NR<=2 { printf "%s %s ",$1,$2 }'
  echo
  rm -rf $dir
done
