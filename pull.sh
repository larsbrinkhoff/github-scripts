#!/bin/sh

set -x
set -e

DIR=`dirname $0`

sh $DIR/fetch.sh &&
  sh $DIR/rebase.sh &&
    git push -f --all

git checkout master && bundle exec rake samples
