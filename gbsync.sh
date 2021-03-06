#####################################################
# Description: Recursively synchronize git branches
# on current Repo/Submodules folder
#
# usage:
# create new branch: gbsync -n BRANCH_NAME
# change branch: gbsync -c BRANCH_NAME
# commit message on branch: gbsync -m BRANCH_NAME
# delete branch: gbsync -d BRANCH_NAME
#
# v: 0.5
# 2020 - Cristian Acuña
# github: codigonet
#####################################################
gbsync(){
  if [ "$GBSYNC_ROOT" = "" ]; then
    local GBSYNC_OPTION="$1"
    local GBSYNC_NAME="$2"
    local GBSYNC_COMMIT_MESSAGE="$3"
    local GBSYNC_ROOT="$PWD"

    if [ "$GBSYNC_NAME" = "" ]; then
      GBSYNC_NAME="$1"
      GBSYNC_OPTION="-n"
    fi

    if [ "$GBSYNC_OPTION" != "-n" ] && \
      [ "$GBSYNC_OPTION" != "-c" ] && \
      [ "$GBSYNC_OPTION" != "-p" ] && \
      [ "$GBSYNC_OPTION" != "-m" ] && \
      [ "$GBSYNC_OPTION" != "-d" ]; then
      echo "Incorrect option: $GBSYNC_OPTION"
      echo "Use: -n for new branch, -c to change branch, -m to commit message on branch, -d to delete branch"
      return 1
    fi
  fi

  if [ -d "$PWD/.git" ] || [ -f "$PWD/.git" ]; then
    if [ "$GBSYNC_OPTION" = "-n" ]; then
      echo "On path [$PWD] - creating branch [$GBSYNC_NAME]"
      git checkout -b $GBSYNC_NAME
    fi
    if [ "$GBSYNC_OPTION" = "-c" ]; then
      echo "On path [$PWD] - changing branch [$GBSYNC_NAME]"
      git checkout $GBSYNC_NAME
      git pull
    fi
    if [ "$GBSYNC_OPTION" = "-d" ]; then
      echo "On path [$PWD] - back to master and deleting branch [$GBSYNC_NAME]"
      git checkout master
      git branch -D $GBSYNC_NAME
    fi
    if [ "$GBSYNC_OPTION" = "-m" ]; then
      echo "On path [$PWD] - message commit on branch [$GBSYNC_NAME]"
      git add .
      git commit -am $GBSYNC_COMMIT_MESSAGE
    fi
  fi

  for d in $PWD/*; do
    if [ -d "$d" ]; then
      # echo "Find recursively repo/submodule on: $d"
      cd $d
      gbsync $GBSYNC_OPTION $GBSYNC_NAME $GBSYNC_COMMIT_MESSAGE
    fi
  done
  
  cd $GBSYNC_ROOT
  return
}
#####################################################
