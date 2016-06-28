#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# install the update_config scripts
SETUPDIR=$(dirname $(readlink -f $0))
sudo mkdir -p /opt/cimon > /dev/null 2>&1
sudo chmod a+rwx /opt/cimon > /dev/null 2>&1
mkdir -p /opt/cimon/update_config
cp $SETUPDIR/update_config.sh /opt/cimon/update_config/update_config.sh
cp $SETUPDIR/dump_addresses.sh /opt/cimon/update_config/dump_addresses.sh
chmod a+rx /opt/cimon/update_config/*.sh
sudo cp $SETUPDIR/cron.d/update_config /etc/cron.d/update_config
sudo chmod g-x,o-x /etc/cron.d/update_config
