# Cimon scripts
Copyright (C) Schweizerische Bundesbahnen SBB 2016, Apache Licence 2.0. Author: Florian Seidl (Github: florianseidl) 

Setup the cimon device, start/stop scripts, auto update and so on. Tested on Raspberry Pi 3.

## Recomended usage (setup)
* Setup keyboard, freesbb and config key if required as descripted in prerequistes
* Clone this repository 
* Set the hostname using set_hostname.sh
* Call setup.sh
* Call setup_update_config.sh
* Call setup_freesbb.sh if not installed allready and if FreeSBB WLAN is required

## Prerequisites
* Setup Keyboard (Keyboard: "Menu->Preferences->Rasberry Pi Configuration") if required (default is UK)
* Make sure the Raspberry Pi is connected to an network with unblocked access to the internet
** If you need the FreeSBB WLAN as a prerequiste, checkout this repository and

    # on host computer
    cp -r cimon_setup/freesbb <usbstick>
    cp cimon_setup/setup_freesbb.sh <usbstick>
    # setup freesbb WLAN
    cd /media/pi/<usbstick>
    ./setup_freesbb.sh 
    
* If passwords in the config are encrypted, copy the config key (binary file, 32 bit) into the cimon directory in your home directory. For instance put them onto the memory stick too.

    cd /media/pi/<usbstick>/
    # if freesbb WLAN is required
    cp /media/pi/<usbstick>/key.bin ~/cimon/key.bin

## Clone this repository
    
    mkdir /tmp/cimon_github
    cd /tmp/cimon_github
    # per default use master branch, if not user -b <branch> (for instance -b develop)
    git clone https://github.com/SchweizerischeBundesbahnen/cimon_setup.git -b master

## set_hostname.sh: Set a meaningfull hostname
Per default all raspberries have the same hostname. Set something usefull.

    cd /tmp/cimon_github/cimon_setup
    ./set_hostname.sh <hostname> 

## setup.sh: Setup raspberry and install controller, drivers and chromium
    
setup.sh will upgrade all packages and install:
* python3.4-dev
* dos2unix
* raspi-config
* clewarecontrol (for the Cleware USB traffic light)
* sispmctl (for the Energenie power socket)
* chromium browser
* cimon controller scripts (including start/stop script and cronjob for supervision) - see https://github.com/SchweizerischeBundesbahnen/cimon_controller repository
* autoupdate for cimon (cimon_setup and cimon_controller directly from GIT master branch)

It will also set the timezone to Zurich

    # setup script
    cd /tmp/cimon_github/cimon_setup
    ./setup.sh 

* Configure the CIMON Controller 
** if you dont use the mydrive remote configuration, open your mydrive and edit the config file at config/<hostname>/cimon.yaml. You can add plugins (collectors and output) within config/<hostname>/plugins
** If you set up locally on the Raspberry Pi (recomended: use setup_update_config.sh and update the config via mydrive.ch) 

    # configure Jenkins Views, Ouput devices,...
    vi ~/cimon.yaml    
  
## setup_freesbb.sh: Setup FreeSBB WLAN Access
The configuration for FreeSBB WLAN with a Python Script to handle autoconnect as long as SMS-Registration is valid (using a request to search.ch). This check is configured to occur every 2 minutes per default, edit /etc/cron.d/freesbb to change. Setup using

    # setup freesbb WLAN
    cd /tmp/cimon_github/cimon_setup
    ./setup_freesbb.sh

## setup_update_config.sh: Update the config from mydrive.ch
Update the configuration from mydrive.ch (Read from mydrive.ch every 5 minutes and copy if changed). Will copy configuration and plugins from the folder config/<hostname> on the mydrive.

Prerequisite: you need to have set a meaningfull, unique hostname. Requires 2 parametes: mydrive user and password

    # setup freesbb WLAN
    cd /tmp/cimon_github/cimon_setup
    ./setup_update_config.sh <user> <password>
    
Now you will have a folder config/<hostname> on your mydrive. If you have a config/templates directory, you will have the config.yaml from there copied to your directory.

## update.sh: Autoupdate entrance point
The git Autoupdate will clone this repository (cimon_setup) and call update.sh.