#!/bin/bash

cwd=`pwd`
cd `dirname $0`
BINDIR=`pwd`
cd $cwd
BASENAME=`basename $0`
ETCDIR=$BINDIR/../etc

usage() {
  echo "Usage: $BASENAME [options] [backup dir]"
  exit 1
}

BACKUP_DIR=$1/backup.tar.gz
GROUPS_FILE=$ETCDIR/groups.conf

cat "$GROUPS_FILE" | while read groupname; do

  if [ ! "$(getent group $groupname)" ]; then # check if group exists
    echo "WARNING: group $groupname doesn't exists."
    continue
  fi

  for username in $(getent group $groupname | cut -d: -f4); do
    if [ ! "$(getent passwd $username)" ]; then # check if user exists
      echo "WARNING: user $username doesn't exists."
      continue
    fi

    home_dir=$(getent passwd $username | cut -d: -f6)

    if [ -f $BACKUP_DIR ]; then
      tar -rf $BACKUP_DIR $home_dir
    else
      tar -cf $BACKUP_DIR $home_dir
    fi
    echo "SUCCESS: created backup for user $username ($groupname) > $home_dir"
  done
done