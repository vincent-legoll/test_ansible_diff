#!/bin/bash

# 2.18 not available
# 2.11 cannot import name 'environmentfilter' from 'jinja2.filters'
ANSIBLE_CORE_VERSIONS_FULL='2.17 2.16 2.15 2.14 2.13 2.12'
ANSIBLE_CORE_VERSIONS='2.16 2.15'

LOG='test_ansible_diff_bug.log'
echo -n > "$LOG"

for ACV in $ANSIBLE_CORE_VERSIONS ; do

  echo "################################################################" >> "$LOG"
  echo "### Testing ansible-core==$ACV" >> "$LOG"
  echo "################################################################" >> "$LOG"

  VENV="venv-ansible-core-$ACV"
  if [ ! -d "$VENV" ] ; then
    python3 -m venv "$VENV"
    . "$VENV/bin/activate"
    pip install -U pip
    pip install "ansible-core==$ACV"
    deactivate
  fi
  
  . "$VENV/bin/activate"
  ansible-playbook -i "localhost," -e 'ansible_connection=local' test_ansible_diff_bug.yml >> "$LOG"
  deactivate

done
