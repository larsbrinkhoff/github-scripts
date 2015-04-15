samples=lib/linguist/samples.json
test -n "`find samples -newer $samples`" && bundle exec rake samples

test -d "$1/.git" && bundle exec linguist "$1"
test -z "$2" && exit 0

find "$1" -name .git -prune -o -type f -iname "*.$2" -print | while read i; do
  echo -n "$i: "
  bundle exec linguist "$i" | awk '/language:/ { print $2 }'
done
