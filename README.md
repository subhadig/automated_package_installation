# automated_package_installation

Automated scripts to install packages and configure an Ubuntu server

**Details:** This script automates the installation of the 
following packages:					
	1. default-jre					
	2. mysql-server					

It also does the below jobs:				
	1. runs the mysql_secure_installation script	
	2. enables ufw					
	3. allows ssh and selected port for http	
							
**Usage:** sudo ./automate.sh <mysql_root_password>

**Compatibility:** This script is tested and is known to work with a fresh installation of Ubuntu 16.04.1. However it should work with other versions of Ubuntu and Ubuntu based distros with little or no change.

**License:** This script is made available under MIT license.
