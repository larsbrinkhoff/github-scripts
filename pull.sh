set -x
set -e

sh fetch.sh &&
  sh rebase.sh &&
    git push -f --all

git checkout master && bundle exec rake samples
