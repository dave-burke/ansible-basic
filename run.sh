#!/bin/bash

set -e

export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible-vault-key

ansible-playbook site.yml -i hosts -u root $@

