#!/usr/bin/env bash
set -e

if [[ -z "$1" ]]; then
    echo "please specify a tag to build"
    exit -1
fi

VERSION="$1"
SUFFIX="$2"

TAG="$VERSION$SUFFIX"

if [[ ! -z "$(git tag | grep "^$TAG\$")" ]]; then
    echo "tag $1 already exists"
    exit -1
fi

work="$PWD"
test -f "$work/$0"

td="$(mktemp -d)"
cd "$td"
npm install codemirror@$VERSION


cd "$work"
rsync -car --delete --exclude .git --exclude component-tools "$td/node_modules/codemirror/" "$work/"
cp component-tools/bower.json "$work/"
rm -rf "$td"

git add -A
git commit -am "Build component $TAG"
git tag -am "release $TAG" $TAG
