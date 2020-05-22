#! /bin/bash

# Need to add attachments


# Get user configs from `configs` file, unset other variables, choose article type, name, and working directory
. configs
unset TEMPLATE FILE NAME SNAME 
case $1 in
    -q | --question )   TEMPLATE=question
                        ;;
    -i | --issue )      TEMPLATE=issue
                        ;;
    -h | --howto )      TEMPLATE=how-to
                        ;;
esac
shift
NAME=${1?What is the name of your article}
WD=$PWD

# slugify the name
slugify () {
  echo "$1" |
  iconv -t ascii//TRANSLIT |
  sed -r s/[^a-zA-Z0-9]+/-/g |
  sed -r s/^-+\|-+$//g |
  tr A-Z a-z
}
SNAME="$(slugify "$NAME")"


# Refresh the repo and create feature branch
echo "refreshing repo and creating feature branch for $SNAME"
cd ../support-kb
git fetch upstream
git rebase upstream/master
git checkout -b "$SNAME"


# Declare folder and file variables
FOLDER="$(readlink -f kbase/knowledge-base/$TEMPLATE/$SNAME)"
FILE="$FOLDER/README.md"


# Create folder and __article__.yaml file
mkdir $FOLDER
echo "name: $NAME" > $FOLDER/__article__.yaml
echo "author: $AUTHOR" >> $FOLDER/__article__.yaml
echo "visibility: $VIS" >> $FOLDER/__article__.yaml
echo "draft: false" >> $FOLDER/__article__.yaml


# Write the article
cp ../support-kb/templates/$TEMPLATE/README.md "$FOLDER/README.md"

echo "created and populated $(readlink -f kbase/knowledge-base/$TEMPLATE/$SNAME) with template.  Opening file in system default editor"
${VISUAL:-${EDITOR:-vi}} $FILE

# Stage changes to the article and finish 
git add $FOLDER
git commit -m \"Add article: $NAME\"
echo "##########################################################"
echo "Done editing.  Changes have been commited. You can now add attachments or make changes befor committing and pushing or start another article."
echo "Here is an example workflow which you can copy and paste to run"
echo ```
echo "cd $FOLDER"
echo "git push origin $SNAME"
echo "./reset-to-upstream.sh"
echo ```
