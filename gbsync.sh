#####################################################
# Description: Recursively synchronize git branches 
# on current Repo/Submodules folder
#
# usage: gbsync BRANCH_NAME
#
# 2020 - Cristian Acuña
# github: codigonet
#####################################################
gbsync(){
  if [ "$GBSYNC_ROOT"="" ]; then
    local GBSYNC_NAME="$1"
    local GBSYNC_ROOT="$PWD"
  fi

  if [ -d "$PWD/.git" ] || [ -f "$PWD/.git" ]; then
    echo "On path [$PWD] - creating branch [$GBSYNC_NAME]"
    git checkout -b $GBSYNC_NAME
  fi

  for d in $PWD/*; do
    if [ -d "$d" ]; then
      # echo "Find recursively repo/submodule on: $d"
      cd $d
      gbsync $GBSYNC_NAME
    fi
  done
  
  cd $GBSYNC_ROOT
  return
}
#####################################################
