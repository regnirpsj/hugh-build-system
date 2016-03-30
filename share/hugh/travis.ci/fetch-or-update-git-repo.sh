#!/bin/sh
set -e

# $1: repository (e.g., http://github.com/g-truc/gli.git)
# $2: directory  (e.g., ${HOME}/extra/gli-git)
# $3: branch     (e.g., 0.8.1)

if [ 2 -gt "$#" ]; then
    echo "need at least two args!"
    exit 1
fi

branch="master"

if [ 4 -lt "$#" ]; then
    branch="$3"
fi

if [ ! -d $2 -o ! -d "$2/.git" ]; then
    echo "creating '$2'"
    mkdir -p $2

    echo "cloning '$1 $branch' -> '$2'"
    git clone --depth 1 -b $branch $1 $2
else
    echo "updating '$2'"
    cd $2
    git pull
fi
