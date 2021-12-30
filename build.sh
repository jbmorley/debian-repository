#!/usr/bin/env bash

set -e
set -o pipefail
set -u

ROOT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ANSIBLE_DIRECTORY="${ROOT_DIRECTORY}/ansible"

"${ROOT_DIRECTORY}/package-repository.py" \
    --output "${ROOT_DIRECTORY}/build" \
    "inseven/elsewhere"

pushd "${ANSIBLE_DIRECTORY}"
ansible-playbook packages.yaml --ask-become-pass
popd
