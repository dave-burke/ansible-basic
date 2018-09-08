#!/bin/bash

set -e

backup_root="{{hostvars[backup_server_host].backup_server_root_dir}}/{{backup_client_user}}/{{inventory_hostname}}"

{% for item in backup_client_dirs %}
# Backup {{item.name | default(item.dir)}}
backup_target="{{ '${backup_root}/' }}{{ item.name|default('$(basename ' + item.dir + ')') }}"
rdiff-backup
{%- if item.exclusions is defined %}
 \
{% for exclusion in item.exclusions %}
	--exclude {{item.dir}}/{{exclusion}} \
{% endfor %}
	{% else %} {% endif %}
{{item.dir}} backup::{{ '"${backup_target}"' }}
rdiff-backup --remove-older-than 3M backup::{{ '"${backup_target}"' }} > /dev/null

{% endfor%}

