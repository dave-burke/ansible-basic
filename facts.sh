#!/bin/bash

set -e

export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible-vault-key

ansible -i hosts $1 -m setup

