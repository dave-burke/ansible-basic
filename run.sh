#!/bin/bash

set -e

export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible-vault-key
export ANSIBLE_STDOUT_CALLBACK=actionable # Only log changed/failed

cd $(dirname ${0})
ansible-playbook site.yml -i hosts -u root $@

