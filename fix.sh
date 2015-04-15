git reset lib/linguist/samples.json
git checkout -- lib/linguist/samples.json 
bundle exec rake samples
git add lib/linguist/samples.json
