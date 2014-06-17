#!/bin/sh

# run this script from the build directory

function gitlog() {
	echo "        "
	echo "        "
	echo "*-----------------------------------------*"
	echo "$1"
	echo "*-----------------------------------------*"
	echo "        "
	git log --all --pretty=format:"https://github.com/gsbitse/$1/commit/%h%n- committer: %cn author: %an, %ar %n%s" --stat --color --since=20.days
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
      gitlog "$i"
      cd ..
    fi  
  done  
}

messageout "!!! status: logs.sh started..."

cd docroot/profiles/gsb_public

cd modules/custom
getlogs

cd features
getlogs

cd ../../../themes
getlogs

messageout "!!! status: logs.sh completed."


