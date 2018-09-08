#!/bin/bash

set -e

{% for item in backup_client_dirs %}
# Backup {{item.dir}}
rdiff-backup
{%- if item.exclusions is defined %}
 \
{% for exclusion in item.exclusions %}
	--exclude {{item.dir}}/{{exclusion}} \
{% endfor %}
	{% else %} {% endif %}
{{item.dir}} backup::"{{hostvars[backup_server_host].backup_server_root_dir}}/{{backup_client_user}}/{{inventory_hostname}}/{{ '$(basename ' }}{{item.dir}}{{ ')' }}"
rdiff-backup --remove-older-than 3M backup::"{{hostvars[backup_server_host].backup_server_root_dir}}/{{backup_client_user}}/{{inventory_hostname}}/{{ '$(basename ' }}{{item.dir}}{{ ')' }}" > /dev/null

{% endfor%}

