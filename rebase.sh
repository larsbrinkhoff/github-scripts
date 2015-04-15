
rebase_one() {
  git checkout $1
  output=`git rebase master 2>&1`

  if test "$?" = 0; then
    echo OK
    return
  fi

  case "$output" in
    *Merge*conflict*in*lib/linguist/samples.json*)
      echo FIX
      sh fix.sh
      git rebase --continue
      ;;
    *)
      echo ERROR
      echo "$output"
      git rebase --abort
      exit 1
      ;;
  esac
}

rebase_all() {
  for i in `git branch | cut -c3- | grep -v master`; do
    rebase_one $i
  done
}

if test -n "$2"; then
  echo "Usage: rebase.sh [branch]"
  exit 1
fi

if test -z "$1"; then
  rebase_all
else
  rebase_one "$1"
fi

exit 0
