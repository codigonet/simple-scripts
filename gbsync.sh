#####################################################
# Description: Recursively synchronize git branches 
# on current Repo/Submodules folder
#
# usage: 
# create new branch: gbsync -n BRANCH_NAME
# delete branch: gbsync -d BRANCH_NAME
#
# v: 0.2
# 2020 - Cristian Acuña
# github: codigonet
#####################################################
gbsync(){
  if [ "$GBSYNC_ROOT" = "" ]; then
    local GBSYNC_OPTION="$1"
    local GBSYNC_NAME="$2"
    local GBSYNC_ROOT="$PWD"

    if [ "$GBSYNC_NAME" = "" ]; then
      GBSYNC_NAME="$1"
      GBSYNC_OPTION="-n"
    fi

    if [ "$GBSYNC_OPTION" != "-n" ] && [ "$GBSYNC_OPTION" != "-d" ]; then
      echo "Incorrect option: $GBSYNC_OPTION"
      echo "Use: -n for new branch or -d to delete branch"
      return 1
    fi
  fi

  if [ -d "$PWD/.git" ] || [ -f "$PWD/.git" ]; then
    if [ "$GBSYNC_OPTION" = "-n" ]; then
      echo "On path [$PWD] - creating branch [$GBSYNC_NAME]"
      git checkout -b $GBSYNC_NAME
    fi
    if [ "$GBSYNC_OPTION" = "-d" ]; then
      echo "On path [$PWD] - back to master and deleting branch [$GBSYNC_NAME]"
      git checkout master
      git branch -D $GBSYNC_NAME
    fi
  fi

  for d in $PWD/*; do
    if [ -d "$d" ]; then
      # echo "Find recursively repo/submodule on: $d"
      cd $d
      gbsync $GBSYNC_OPTION $GBSYNC_NAME
    fi
  done
  
  cd $GBSYNC_ROOT
  return
}
#####################################################