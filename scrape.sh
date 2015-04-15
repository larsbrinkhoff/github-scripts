#QUERY="extension%3Afor+weekly+-language%3Aformatted"
QUERY="dup+swap+language%3Afortran"
> TMP
for i in `seq 1 75`; do
  echo "$i " 1>&2
  URL="https://github.com/search?p=$i&q=$QUERY&type=Code"
  curl "$URL" 2> /dev/null |
    grep /blob/ | grep -v '#' | awk -F'"' '{print $2}' | cut -d/ -f1-3 >> TMP
  sleep 10
done

cat TMP | while read i; do
  echo "https://github.com$i"
done | sort -u > query.csv
