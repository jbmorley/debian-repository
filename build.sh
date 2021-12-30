#!/usr/bin/env bash

set -e
set -o pipefail
set -u

ROOT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ANSIBLE_DIRECTORY="${ROOT_DIRECTORY}/ansible"
BUILD_DIRECTORY="${ROOT_DIRECTORY}/build"

if [ -d "${BUILD_DIRECTORY}" ] ; then
    rm -r "${BUILD_DIRECTORY}"
fi
mkdir -p "${BUILD_DIRECTORY}"

"${ROOT_DIRECTORY}/package-repository.py" \
    --output "${BUILD_DIRECTORY}/raspbian" \
    "inseven/elsewhere"

pushd "${ANSIBLE_DIRECTORY}"
ansible-playbook packages.yaml
popd
