#!/bin/bash

# run this script from the build directory

function gitlog() {
	echo "        "
	echo "        "
	echo "*-----------------------------------------*"
	echo "$1"
	echo "*-----------------------------------------*"
	echo "        "
	# git log --pretty=format:"%h - %an, %ar : %s" --committer "Greg Mercer" --stat --color --since=1.days
	git log --all --pretty=format:"https://github.com/gsbitse/$1/commit/%h%n- committer: %cn author: %an, %ar %n%s" --stat --color --since=$2.days
}

function messageout() {
	echo "    "
	echo "    "
	echo "$1"	
}

function getlogs() {
  for i in $(find . -maxdepth 1 -type d) 
  do 
    if [ "$i" == "./features" ]; then
      :
    elif [ "$i" == "./modules" ]; then  
      :
    elif [ "$i" == "." ]; then  
      :   
    else
      cd "$i"   
      gitlog "$i" "$1"
      cd ..
    fi  
  done  
}

messageout "!!! status: logs.sh started..."

cd gsb_public/profiles/gsb_public/

cd modules/custom
getlogs $1

cd features
getlogs $1

cd ../../../themes
getlogs $1

messageout "!!! status: logs.sh completed."
