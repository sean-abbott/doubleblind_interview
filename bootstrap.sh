#!/usr/bin/env bash

set -euo pipefail

vagrant plugin install vagrant-hostmanager
ansible-galaxy install --force -r role_requirements.yml
