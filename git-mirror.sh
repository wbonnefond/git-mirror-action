#!/bin/sh

set -e

SOURCE_REPO=$1
DESTINATION_REPO=$2

GIT_SSH_COMMAND="ssh -v"

echo "SOURCE=$SOURCE_REPO"
echo "DESTINATION=$DESTINATION_REPO"

git clone --mirror "$SOURCE_REPO" && cd `basename "$SOURCE_REPO"`
#git remote set-url --push origin "$DESTINATION_REPO"
git remote add mirror "$DESTINATION_REPO"
git config --unset-all remote.origin.fetch
git config --add remote.origin.fetch "+refs/heads/*:refs/heads/*"
git config --add remote.origin.fetch "+refs/tags/*:refs/tags/*"
git fetch -p origin
# Exclude refs created by GitHub for pull request.
git for-each-ref --format 'delete %(refname)' refs/pull | git update-ref --stdin
git push mirror
