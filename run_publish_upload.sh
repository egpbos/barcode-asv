#!/usr/bin/env sh

# exit on error
set -e

# cd to script location
cd "$(dirname "$0")"

asv run
asv publish

git add .asv/results/*/*.json
git add docs

hostname=$(hostname)
git commit -a -m "[skip ci] New results from ${hostname}"
git push
