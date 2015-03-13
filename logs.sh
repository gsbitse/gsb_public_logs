#!/bin/sh

# run this script from the build directory

function gitlog() {
  echo "<p>"   
  echo "==========================================="
  echo "</br>"  
	echo "<strong>$1</strong>"
  echo "</br>"  
	echo "==========================================="
  echo "</br>"  
  commitlink="<a href=!https://github.com/gsb-public/$1/commit/%h%n! view commit</a>"
  git config --global alias.lg "log --all --pretty=format:'$commitlink - committer: %cn author: %an, %ar %b %n %s %N'" 
  git lg --stat --since=$2.days > tmp1.out
  sed $'s/\x3d\x21/\x3d\x22/g' tmp1.out > tmp2.out
  tr '\012' '\011' < tmp2.out > tmp1.out
  sed $'s/\x09\x21/\x22\x3e/g' tmp1.out > tmp2.out 
  sed $'s/\x09/\x3c\\/\x62\x72\x3e/g' tmp2.out > out.html
  cat out.html
  echo "</br>"
  echo "</p>" 
}

function messageout() {
  echo "<p>" 
  echo "    "
  echo "    "
  echo "$1"
  echo "</p>"	
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

echo '<!doctype html>
<html class="no-js" lang="">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title></title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>

    <!--[if lt IE 8]>
        <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
    <![endif]-->'

messageout "!!! status: logs.sh started..."

cd docroot/profiles/gsb_public

cd modules/custom
getlogs $1

cd features
getlogs $1

cd ../../../themes
getlogs $1

messageout "!!! status: logs.sh completed."

echo '<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
  </body>
</html>' 


