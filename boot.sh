#!/bin/bash

set -e

cd $(dirname "${0}")

usage() {
    cat <<EOF
Initialize a new server for generic use.

Usage: boot.sh [host]

Example:

    boot.sh example.com

EOF
}

[[ $# -gt 0 ]] || { usage; exit 0; }

HOST="${1}"

# Ansible requires python
ssh root@${HOST} "apt-get -y update && apt-get -y upgrade && apt-get -y install python"

ansible-playbook basic.yml -i ${HOST}, -u root

