#!/bin/bash
set -euxo pipefail

config_path=/config
data_path=/opt/geneshift/data

# When config files are provided link into game dir
[ -e "${config_path}/config.ini" ] && ln -sf ${config_path}/config.ini ${data_path}/config.ini
[ -e "${config_path}/weapons.ini" ] && ln -sf ${config_path}/weapons.ini ${data_path}/weapons.ini

exec /opt/geneshift/GeneshiftServer
