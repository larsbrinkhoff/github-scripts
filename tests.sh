#!/bin/sh

check() {
  git checkout $1
  sh `dirname $0`/test.sh
}

for i in `git branch | cut -c3- | grep -v master`; do
  echo -n "Testing $i ... "
  if check $i > /dev/null 2>&1; then echo PASS; else echo FAIL; fi
done
