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

echo "Commit and push to your feature branch?"
select yn in "Yes" "No"; do
    case $yn in
        # If yes, stage changes to the article, push, and add to list of articles you've written
        Yes ) echo "updating my-articles.list"
          echo $FOLDER >> ../kb-tools/my-articles.list ; 
          echo "adding, commiting, and pushing"
          git add $FOLDER ;
          git commit -m \"Add article: $NAME\" ;
          git push origin $SNAME ;
          echo "##########################################################"
          echo "Done editing.  Changes have been commited and pushed to your fork-branch. You can now add attachments or make changes before committing and pushing or just create another article and come back to this branch later."
          echo
          echo "You can now resync to the main KB branch by running ./reset-to-upstream.sh and/or file your pull request from github"
          break;;
        No ) echo "no changes have been staged or committed.  The support-kb directory is still on your feature branch" ; exit;;
    esac
done

