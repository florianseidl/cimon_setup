#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# install the update_config scripts
SETUPDIR=$(dirname $(readlink -f $0))
MODE=$(cat ~/cimon/.update_config_mode)

if [[ "$MODE" != "github" && "$MODE" != "mydrive" ]]; then
    echo "Invalid update_config_mode mode $MODE"
    exit 90
fi

pushd .

cd $SETUPDIR

git rev-parse --is-inside-work-tree  1>/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    GIT="true"
fi

if [[ $GIT ]]; then
   REV=$(git rev-parse HEAD)
else
   REV="unknown-version"
fi
# if no version file (for instance new installation) or version has changed
if [[ ! -f /opt/cimon/update_config/version || $(cat /opt/cimon/update_config/version) != $REV ]]; then
    SETUPDIR=$(dirname $(readlink -f $0))
    sudo mkdir -p /opt/cimon > /dev/null 2>&1
    sudo chmod a+rwx /opt/cimon > /dev/null 2>&1
    mkdir -p /opt/cimon/update_config
    cp -f $SETUPDIR/$MODE/update_config.sh /opt/cimon/update_config/update_config.sh
    cp -f $SETUPDIR/copy_restart_if_changed.sh /opt/cimon/update_config/copy_restart_if_changed.sh
    cp -f $SETUPDIR/dump_addresses.sh /opt/cimon/update_config/dump_addresses.sh
    chmod a+rx /opt/cimon/update_config/*.sh
    sudo cp -f $SETUPDIR/cron.d/update_config /etc/cron.d/update_config
    sudo chmod g-x,o-x /etc/cron.d/update_config
    if [[ $GIT ]]; then
        git rev-parse HEAD > /opt/cimon/update_config/version
    else
        rm -f /opt/cimon/update_config/version  1>/dev/null 2>&1
    fi
fi
popd