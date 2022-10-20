#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo -e "\nThis script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else
	
	if [ -r /etc/os-release ]; then
		os="$(. /etc/os-release && echo -e "$ID")"
	fi
	
	if [[ $os == "ubuntu" ]]; then
		if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
			dateis=$(date +%d%m%Y)
		        timeis=$(date +%H%M%S)
		        uname=$(cat /DNIF/DL/csltuconfig/username)
		        export HADOOP_USER_NAME=$uname
		        cd /opt/hadoop-3.2.3/bin/
        		./hdfs dfsadmin -report >> /var/tmp/dfsadmin_$dateis"T"$timeis.out
			echo -e "\ndfsadmin report generated successfully!!!\n"
			echo -e "path: /var/tmp/dfsadmin_$dateis"T"$timeis.out\n"
		else
			echo -e "\nThis is not the CORE server!!!\n"
			echo -e "This script should be executed on the CORE server only!!!\n"
		fi
	fi
	
	if [[ $os == "rhel" ]]; then
                if [[ $(podman ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
			dateis=$(date +%d%m%Y)
	 	       	timeis=$(date +%H%M%S)
	 	       	uname=$(cat /DNIF/DL/csltuconfig/username)
	 	       	export HADOOP_USER_NAME=$uname
	 	       	cd /opt/hadoop-3.2.3/bin/
 		       	./hdfs dfsadmin -report >> /var/tmp/dfsadmin_$dateis"T"$timeis.out
			echo -e "\ndfsadmin report generated successfully!!!\n"
                        echo -e "path: /var/tmp/dfsadmin_$dateis"T"$timeis.out\n"
		else
                        echo -e "\nThis is not CORE server!!!\n"
                        echo -e "This should be executed in CORE server only!!!\n"
                fi
        fi
fi
