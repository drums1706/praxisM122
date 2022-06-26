#!/bin/bash

cwd=`pwd`
cd `dirname $0`
BINDIR=`pwd`
cd $cwd
BASENAME=`basename $0`
ETCDIR=$BINDIR/../etc
TEMPDIR=/tmp/homebackup
mkdir $TEMPDIR

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

echo "using prefix $BACKUP_PREFIX"

BACKUP_DIR=$1/home-backup.tar.gz

GROUPS_FILE=$ETCDIR/groups.conf
cat "$GROUPS_FILE" | while read groupname; do

  if [ ! "$(getent group $groupname)" ]; then # check if group exists
    echo "WARNING: group $groupname doesn't exists."
    continue
  fi

  for username in $(grep ^$groupname:.*$ /etc/group | cut -d: -f4 | sed 's/,/ /g'); do # get all users space separated
    if [ ! "$(getent passwd $username)" ]; then # check if user exists
      echo "WARNING: user $username doesn't exists."
      continue
    fi

    home_dir=$(getent passwd $username | cut -d: -f6)

    if [ ! "$home_dir" ]; then # check if user home exists
      echo "WARNING: user $username has no home. Skipping..."
      continue
    fi

    tmp_user_name=$(getent passwd $username | cut -d/ -f3 | cut -d: -f1)
    user_backup_dir="$BACKUP_PREFIX$tmp_user_name"

    cd $TEMPDIR
    cp -r $home_dir . && mv $tmp_user_name $user_backup_dir >> /dev/null

    if [ -f $BACKUP_DIR ]; then
      tar -rf $BACKUP_DIR $user_backup_dir
    else
      tar -cf $BACKUP_DIR $user_backup_dir
    fi
    cd $cwd
    echo "SUCCESS: created backup for user $username ($groupname) > $home_dir"
  done
  rm -rf $TEMPDIR
done