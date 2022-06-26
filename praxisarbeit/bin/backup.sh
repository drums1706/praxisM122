#!/bin/bash

cwd=`pwd`
cd `dirname $0`
BINDIR=`pwd`
cd $cwd
BASENAME=`basename $0`
ETCDIR=$BINDIR/../etc
TEMPDIR=/temp/homebackup

usage() {
  echo "Usage: $BASENAME [options] [backup dir]"
  exit 1
}

while getopts p optvar; do
    case $optvar in
		p) BACKUP_PREFIX=${OPTARG} && shift ;;
		*) usage ;;
	esac
    shift
done

BACKUP_DIR=$1/home-backup.tar.gz

GROUPS_FILE=$ETCDIR/groups.conf
cat "$GROUPS_FILE" | while read groupname; do

  if [ ! "$(getent group $groupname)" ]; then # check if group exists
    echo "WARNING: group $groupname doesn't exists."
    continue
  fi

  for username in $(getent group $groupname | cut -d: -f1); do
    if [ ! "$(getent passwd $username)" ]; then # check if user exists
      echo "WARNING: user $username doesn't exists."
      continue
    fi

    home_dir=$(getent passwd $username | cut -d: -f6)
    foldername=$(getent passwd $username | cut -d/ -f3 | cut -d: -f1)
    echo "$home_dir > $TEMPDIR; $foldername"
    cp -r $home_dir $TEMPDIR

    if [ -f $BACKUP_DIR ]; then
      tar -rf -C $BACKUP_DIR $TEMPDIR/$foldername
    else
      tar -cf -C $BACKUP_DIR $TEMPDIR/$foldername
    fi
    echo "SUCCESS: created backup for user $username ($groupname) > $home_dir"
    rm -rf $TEMPDIR/$foldername
  done
done