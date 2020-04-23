#! /bin/bash
. configs
git clone "$REPO" ../support-kb
cd ../support-kb
git remote add upstream "$UPSTREAM"

