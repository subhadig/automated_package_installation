#!/bin/bash

#########################################################
# This script automates the installation of the		#
# following packages:					#
#	1. default-jre					#
#	2. mysql-server					#
# It also does the below jobs:				#
#	1. runs the mysql_secure_installation script	#
#	2. enables ufw					#
#	3. allows ssh and selected port for http	#
#							#
# Usage: sudo ./automate.sh <mysql_root_password>	#
#########################################################

export DEBIAN_FRONTEND=noninteractive

# Properties
mysql_version='5.7'
mysql_password=$1
mysql_secure_installation_script_loc='mysql_secure_installation_script.exp'
http_port=8761

function log {
	echo automate.sh: `date '+%F %r'`: $1
}

log "Checking mysql root password"
if test -z $mysql_password;
then
	log "Please provide the mysql root password as argument"
	log "Exiting"
	exit 1
fi

log "Checking user priviledge"
if test $EUID -ne 0;
then
	log "Please run the script with root priviledge"
	log "Exiting"
	exit 1
fi

log "Checking if necessary files are available"
if test ! -f $mysql_secure_installation_script_loc;
then
	log "$mysql_secure_installation_script_loc does not exists"
	log "Exiting"
	exit 1
fi

log "Initiating automated package installation"

log "Updating repository"
apt-get update -q

log "Installing debconf-utils"
apt-get install -q -y -o Dpkg::Options::="--force-confdef" debconf-utils

log "Installing expect"
apt-get install -q -y -o Dpkg::Options::="--force-confdef" expect

log "Installing default-jre"
apt-get install -q -y -o Dpkg::Options::="--force-confdef" default-jre 

log "Installing mysql-server"
echo mysql-server-${mysql_version} mysql-server/root_password password ${mysql_password} | debconf-set-selections
echo mysql-server-${mysql_version} mysql-server/root_password_again password ${mysql_password} | debconf-set-selections
apt-get install -q -y -o Dpkg::Options::="--force-confdef" mysql-server

log "Running mysql_secure_installation"
./$mysql_secure_installation_script_loc -d $mysql_password

log "Enabling ufw"
echo y | ufw enable

log "Allowing ssh port"
ufw allow ssh

log "Allowing http port:$http_port"
ufw allow $http_port/tcp

log "Complete. Exiting script with zero value"
exit 0
