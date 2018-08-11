#!/bin/bash

tag=$1
if [ "$tag" = '' ]; then
    echo 'tag param emited, get latest tag from github.com/YMFE/yapi'
    tag=`git ls-remote --tags https://github.com/YMFE/yapi.git | awk '{print $2}' | awk -F'/' '{print $3}' | tr -d 'v' | sort -rV | head -n 1`
    echo "latest tag is $tag"
fi

echo 'check local tags'
git tag | grep $tag > /dev/null

if [ $? -ne 0 ]; then
    echo "tag $tag dosen't exist, update Dockerfile and docker-compose file"
    sed "s/__VERSION__/$tag/g" Dockerfile.tpl > Dockerfile
    sed "s/__VERSION__/$tag/g" docker-compose.tpl.yml > docker-compose.yml
    echo 'pushing tag'
    git add -A
    git commit -m "Add tag $tag"
    git tag $tag
    git push --tags
    git push origin master
else
    echo "tag $tag exists, abort."
fi
