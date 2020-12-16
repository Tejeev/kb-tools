#! /bin/bash

# Need to add attachments
#set -xv
unset TEMPLATE FILE NAME SNAME

read_variables(){
  echo "== variables =="
  echo "Options: $TYPE $NAME"
  echo "Names: $NAME $SNAME"
  echo "Working Directory: $WD"
  echo "Folder: $FOLDER"
  echo "File: $FILE"
  echo "== variables =="
}


main() {
#  TYPE=( "$1" )
  set_os_dependent_commands
  read_options $@
#  set_environment $2
#  read_variables
#  refresh
#  read_variables
#  create_article
}


#use GNU sed and readlink on macos
set_os_dependent_commands() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    SED_CMD='gsed'
    READLINK_CMD='greadlink'
  else
    SED_CMD='sed'
    READLINK_CMD='readlink'
  fi
}



# Read in options from CLI and create branch
read_options(){
  echo "0 $0"
  echo "1 $1"
  echo "2 $2"
  echo "3 $3"
  
  if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
  elif [ !"$2" ]; then
    echo "no article name provided"
    exit 1
  else
    case $1 in
      -q | --question )
        TEMPLATE=question
        create_branch
        ;;
      -i | --issue )
        TEMPLATE=issue
        create_branch
        ;;
      -h | --howto )
        TEMPLATE=how-to
        create_branch
        ;;
      -e | --edit )
        edit_branch
        ;;
      *)
        echo "ERROR: please use a valid article type: (q)uestion, (i)ssue, (h)ow to, (e)dit"
        exit 1
        ;;
    esac
    shift
    NAME=( "$2" )
  fi
}


# Set up environment
#   user configs from `configs` file
#   unset other variables
#   choose article type, name, and working directory
set_environment() {
  . configs
  SNAME="$(slugify "$NAME")"
#  WD=$PWD   # Set current working directory for future refernce

  # Declare folder and file variables
  FOLDER="$($READLINK_CMD -f kbase/knowledge-base/$TEMPLATE/$SNAME)"
  FILE="$FOLDER/README.md"
}

# Create feature branch
create_branch() {
  git checkout -b "$SNAME"
}

# Switch to feature branch
edit_branch() {
  git checkout "$SNAME"
}





# slugify the name
slugify () {
  echo "$1" |
  iconv -t ascii//TRANSLIT |
  $SED_CMD -r s/[^a-zA-Z0-9]+/-/g |
  $SED_CMD -r s/^-+\|-+$//g |
  tr A-Z a-z
}



# Refresh the repo
refresh () {
  echo "refreshing repo and creating feature branch for $SNAME"
  cd ../support-kb
  git remote add upstream $UPSTREAM
  git checkout master
  git pull upstream master
  git reset --hard upstream/master
}



# Create folder and __article__.yaml file
create_article() {
  mkdir $FOLDER
  echo "name: $NAME" > $FOLDER/__article__.yaml
  echo "author: $AUTHOR" >> $FOLDER/__article__.yaml
  echo "visibility: $VIS" >> $FOLDER/__article__.yaml
  echo "draft: false" >> $FOLDER/__article__.yaml

  # Write the article
  cp ../support-kb/templates/$TEMPLATE/README.md "$FOLDER/README.md"
  echo "created and populated $($READLINK_CMD -f kbase/knowledge-base/$TEMPLATE/$SNAME)\
    with template.  Opening file in system default editor"
  ${VISUAL:-${EDITOR:-vi}} $FILE

  # Add article to list of articles you've written
  echo $FOLDER >> ../kb-tools/my-articles.list ;
}









close_out(){
  echo "Do you want to:"
  select q in "Commit" "Push" "Quit"; do
      case $q in
          # Stage changes to the article and push
          Push ) echo "updating my-articles.list"

            echo "adding"
            git add $FOLDER ;

            echo "commiting"
            git commit -m "Add article: $NAME" ;

            echo "pushing"
            git push origin $SNAME ;

            echo "##########################################################"
            echo "Done editing
              Changes have been commited and pushed to your fork-branch.
              You can now add attachments or make changes before committing and pushing \
              or just create another article and come back to this branch later."
            echo
            echo "You can now resync to the main KB branch by running ./reset-to-upstream.sh\
              and/or file your pull request from github"
            break;;

          # Commit article but do not push
          Commit )
            git add $FOLDER ;
            git commit -m "Add article: $NAME" ;
            echo "Changes have been saved and committed
            The support-kb directory is still on your feature branch" ;
            break;;

          # Quit without saving.  Do not pass go
          Quit )
            exit;;
      esac
  done
}


main "$@"
