#!/bin/bash

set -e

export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible-vault-key

cd $(dirname ${0})
ansible-playbook site.yml -i hosts -u root $@

