#!/bin/sh

git fetch upstream && git checkout master && git merge --ff-only upstream/master
