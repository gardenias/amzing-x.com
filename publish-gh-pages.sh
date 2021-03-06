#!/bin/sh

DIR=$(dirname "$0")

cd $DIR

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Update the whole git repo"
git fetch -p

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree remove gh-pages
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Copy from build to public"
cp -R build/* public/
mv public/README.html public/index.html

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "$1"

echo "Publish the site"
git push origin gh-pages
