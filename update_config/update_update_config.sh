#!/usr/bin/env bash
# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# install the monitoring scripts
SETUPDIR=$(dirname $(readlink -f $0))

pushd .

cd $SETUPDIR

git rev-parse --is-inside-work-tree  1>/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Not in a git repository dir $(pwd)"
    exit 82
fi

# if no version file (for instance new installation) or version has changed
if [[ ! -f /opt/cimon/update_config/.version ]] || [[ $(cat /opt/cimon/update_config/.version) != $(git rev-parse HEAD) ]]; then
    mkdir -p /opt/cimon/update_config
    cp -f $SETUPDIR/update_config.sh /opt/cimon/update_config/update_config.sh
    cp -f $SETUPDIR/copy_restart_if_changed.sh /opt/cimon/update_config/copy_restart_if_changed.sh
    # remove files left over from before monitoring was its own directory
    if [[ -f /opt/cimon/update_config/mail_address.sh ]]; then
        rm /opt/cimon/update_config/mail_address.sh
    fi
    if [[ -f /opt/cimon/update_config/dump_addresses.sh ]]; then
        rm /opt/cimon/update_config/dump_addresses.sh
    fi
    chmod a+rx /opt/cimon/update_config/*.sh
    sudo cp -f $SETUPDIR/cron.d/update_config /etc/cron.d/update_config
    sudo chmod g-x,o-x /etc/cron.d/update_config
    git rev-parse HEAD > /opt/cimon/update_config/.version
fi

popd