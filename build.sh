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
echo -e "$ANSIBLE_SSH_KEY" > id_ed25519
chmod 0400 id_ed25519
ansible-playbook \
    --extra-vars ansible_ssh_private_key_file=id_ed25519 \
    packages.yaml
rm id_ed25519
popd
