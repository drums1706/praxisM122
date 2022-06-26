#!/bin/bash
#Create User in Group Script

set -xv
cwd=`pwd`		# current working directory
cd `dirname $0`	# change to the directory where the script is located
BINDIR=`pwd`	# BINDIR: the directory where the script is located
cd $cwd		# return to the working directory
BASENAME=`basename $0`	# Set the script name (without path to it)
TMPDIR=/tmp/$BASENAME.$$	# Set a temporary directory if needed
ETCDIR=$BINDIR/../etc		# ETCDIR is the config directory


. $ETCDIR/$BASENAME

#type string - path to your configuration file 
config_path=$1

#type string - default password for the users$
#password=$2

#type boolean - create non existing groups
#create_group=$3



if [ ! $# -eq 3 ]
  then
    echo "No arguments supplied rtfm"
fi

if [ ! -f "$config_path" ]; then
    echo 'Error: ' "$config_path" ' doesnt exist.'
fi

cat "$config_path" | while read username groupname fullname; do

    # check if group exists
    if [ -n "$groupname" ]; then
        if [ "$create_group" = "group" ] ; then #
            echo 'Warning: group "' "$groupname" '" doesnt exist.'
            continue
        fi
        groupadd -f "$groupname"
    else
        echo #test: group is backuped // nicht machbar ohne Backup
    fi

    # check if user exists
    if id "$username" &>/dev/null; then
        echo 'Warning: User ' "$username" ' already exists.'
    else
        useradd -g "$groupname" -k /etc/skel -m -p "$password" "$username" -c "$fullname"
    fi


done
# +set xv