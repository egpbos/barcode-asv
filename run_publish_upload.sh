#!/usr/bin/env sh

# exit on error
set -e

asv run
asv publish

git add .asv/results/*/*.json
git add docs

git commit -a -m "[skip ci] New results from ${HOST}"
git push
