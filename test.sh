#!/bin/sh

samples=lib/linguist/samples.json
export PATH=$HOME/src/node-v0.12.0-linux-x64/bin:$PATH
test -n "`find samples -newer $samples`" && bundle exec rake samples
bundle exec rake test
