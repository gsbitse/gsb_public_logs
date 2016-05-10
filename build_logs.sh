#!/bin/sh

############################################
# set the distro urls

distro_url="https://github.com/gsbitse/gsb-distro.git"

############################################
# save the workspace root directory

workspace_dir=$PWD
branch=$(cat branch_name.txt)

echo '*********** running logs for branch:' $branch 

############################################
# check if the gsb-distro branch exists
# if not exit with an error

cd ${workspace_dir}/gsb-distro

ret_code=$(git ls-remote $distro_url $branch | wc -l | tr -d ' ')
if [[ $ret_code != 1 ]]; then
    echo "gsb-distro branch = $branch not found"
    exit -1
else
    git pull 
fi

############################################
# check if the gsb-distro directory exists
# if it doesn't clone it

cd $workspace_dir

if [ ! -d gsb-distro ]; then
    git clone -b $branch $distro_url
    if [ ! -d gsb-distro ]; then
       echo "gsb-distro cloned failed for branch = $branch"
       exit -1
    fi
    echo "gsb-distro directory created"
else 
    echo "gsb-distro directory exists"
fi

############################################
# checkout the gsb-distro branch
# 

cd ${workspace_dir}/gsb-distro
git checkout $branch

############################################
# create(recreate) the gsbpublic directory

rm -rf ${workspace_dir}/gsbpublic
mkdir ${workspace_dir}/gsbpublic

# cp docroot/sites/default/settings.php ${workspace_dir}/temp/.

############################################
# change to the gsbpublic directory
# and then run the drush make

cd ${workspace_dir}/gsbpublic
git config --global apply.whitespace fix

echo "start drush make"

# php /private/stanfordgsb/drush/drush.php vset date_default_timezone 'America/Los_Angeles' -y
php /private/stanfordgsb/drush/drush.php make --working-copy ../gsb-distro/gsb-public-distro.make docroot

echo "end drush make"

############################################
# run the logs

cd ${workspace_dir}/gsbpublic

sh ${workspace_dir}/logs.sh 1000 > ${workspace_dir}/log_out.html
sh ${workspace_dir}/logs.sh 600 > ${workspace_dir}/log_1y_out.html
sh ${workspace_dir}/logs.sh 10 > ${workspace_dir}/log_10_out.html
sh ${workspace_dir}/logs.sh 1 > ${workspace_dir}/log_1_out.html

#########################################################
# copy the logs over to the gsbitse.github.io web site

cd ${workspace_dir}

rm -rf gsbitse.github.io
git clone git@github.com:gsbitse/gsbitse.github.io.git

cd gsbitse.github.io

echo '' > log_out.html
echo '' > log_1y_out.html
echo '' > log_10_out.html
echo '' > log_1_out.html

git add log_out.html
git add log_1y_out.html
git add log_10_out.html
git add log_1_out.html
git commit -m 'Clear logs'

git push

#########################################################
# copy the logs over to the gsbitse.github.io web site

cd ${workspace_dir}

cp ${workspace_dir}/log_out.html gsbitse.github.io/.
cp ${workspace_dir}/log_1y_out.html gsbitse.github.io/.
cp ${workspace_dir}/log_10_out.html gsbitse.github.io/.
cp ${workspace_dir}/log_1_out.html gsbitse.github.io/.

cd gsbitse.github.io

git add log_out.html
git add log_1y_out.html
git add log_10_out.html
git add log_1_out.html
git commit -m 'New update of logs'

git push








