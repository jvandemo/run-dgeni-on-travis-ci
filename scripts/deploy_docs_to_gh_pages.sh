#!/bin/bash
echo "Starting deployment"
echo "Target: gh-pages branch"

TEMP_DIRECTORY="/tmp/__temp_static_content"
CURRENT_COMMIT=`git rev-parse HEAD`
# ORIGIN_URL=`git config --get remote.origin.url`
COMMIT_MESSAGE=`git log --format=%B --no-merges -n 1`

if [ echo "$COMMIT_MESSAGE" | grep '\[build-docs\]' ]; then
  echo "Building new documentation"
else
  echo "No need to rebuild documentation"
  exit 0
fi

ORIGIN_URL="https://github.com/jvandemo/run-dgeni-on-travis-ci.git"
ORIGIN_URL_WITH_CREDENTIALS=${ORIGIN_URL/\/\/github.com/\/\/$GITHUB_TOKEN@github.com}


mkdir $TEMP_DIRECTORY || exit 1
gulp dgeni || exit 1
cp -r ./dist/docs/* $TEMP_DIRECTORY || exit 1
cp .gitignore $TEMP_DIRECTORY || exit 1

echo "Checking out gh-pages branch"
git checkout -B gh-pages || exit 1

echo "Removing old static content"
git rm -rf . || exit 1

echo "Copying newly generated documentation"
ls -al $TEMP_DIRECTORY || exit 1
cp -r $TEMP_DIRECTORY/* . || exit 1
cp $TEMP_DIRECTORY/.gitignore . || exit 1

echo "Pushing new content to $ORIGIN_URL"
git config user.name "Travis-CI" || exit 1
git config user.email "travis@angular.io" || exit 1

git add -A . || exit 1
git commit --allow-empty -m "Regenerated documentation for $CURRENT_COMMIT" || exit 1
git push --force --quiet "$ORIGIN_URL_WITH_CREDENTIALS" gh-pages > /dev/null 2>&1

echo "Cleaning up temp files"
rm -Rf $TEMP_DIRECTORY

echo "Deployed successfully."
exit 0
