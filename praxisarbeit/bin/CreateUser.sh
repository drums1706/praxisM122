#!/bin/bash

cwd=`pwd`
cd `dirname $0`
BINDIR=`pwd`
cd $cwd
BASENAME=`basename $0`
ETCDIR=$BINDIR/../etc

usage() {
    echo "Usage: $BASENAME [users file] [options]"
    exit 1
}

while getopts p: optvar; do
    case $optvar in
		p) PASSWORD=${OPTARG} && shift ;;
		*) usage ;;
	esac
    shift
done

USERS_FILE=$1
if [ ! -f "$USERS_FILE" ]; then
    echo "ERROR: users file ($USERS_FILE) doesnt exist."
    exit 3
fi

cat "$USERS_FILE" | while read username groupname firstname lastname; do
    if [ ! "$(getent group $groupname)" ]; then # check if group exists
        echo "WARNING: group $groupname doesn't exists. Create new group..."
        groupadd $groupname
    fi

    if [ ! "$(grep ^$groupname$ $ETCDIR/groups.conf)" ]; then # check if group is backed-up by script 2
        echo "WARNING: group $groupname is not a backed-up group."
    fi
   
    if [ "$(getent passwd $username)" ]; then # check if user already exists
        echo "WARNING: user $username already exists. Skipping..."
        continue
    fi

    useradd "$username" -g "$groupname" -m -k /etc/skel -p $(openssl passwd -1 "$PASSWORD") -c "$firstname $lastname"
    passwd --expire "$username" > /dev/null
    echo "SUCCESS: Created user $username ($firstname $lastname) with group $groupname."
done