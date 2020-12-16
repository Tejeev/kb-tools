#! /bin/bash

cd ../support-kb
echo "== BRANCHES"
git branch
printf "\n== FETCHING UPSTREAM\n"
git fetch
printf "\n== STATUS\n"
git status

