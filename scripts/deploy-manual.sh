#!/bin/bash

set -e

work_dir=/home/deploy
cd ${work_dir}
repo=${1:-seafile-docs}

if ! [[ -e ${repo} ]]; then
    echo "Cloing ${repo}"
    git clone -q https://github.com/haiwen/${repo}.git
else
    cd ${repo}
    echo "Updating ${repo}"
    git fetch -q origin
    git reset --hard origin/master
    git clean -fdx
fi

cd ${work_dir}/${repo}/
echo "Building ${repo}"
gitbook build > /dev/null && rm -rf /home/deploy/_book
mv ./_book /home/deploy/

echo "Reloading nginx"
sudo nginx -s reload
echo "done"
