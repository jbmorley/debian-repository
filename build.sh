#!/usr/bin/env bash

set -e
set -o pipefail
set -u

ROOT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ANSIBLE_DIRECTORY="${ROOT_DIRECTORY}/ansible"
BUILD_DIRECTORY="${ROOT_DIRECTORY}/_site"

if [ -d "${BUILD_DIRECTORY}" ] ; then
    rm -r "${BUILD_DIRECTORY}"
fi
mkdir -p "${BUILD_DIRECTORY}"

"${ROOT_DIRECTORY}/create-repository" \
    --output "${BUILD_DIRECTORY}/raspbian" \
    "inseven/elsewhere"

cp index.html "$BUILD_DIRECTORY/index.html"
cp CNAME "$BUILD_DIRECTORY/CNAME"
