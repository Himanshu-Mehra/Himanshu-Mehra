#!/bin/bash
if [[ $EUID -ne 0 ]]; then
	echo -e "This script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else
	cwd=$(pwd)
	f1="/etc/dnif-bar/config.yaml"
	if [ ! -f "$f1 " ]; then
		echo -e "The file $f1 does not exist"
		break
	fi

	f2="/etc/dnif-bar/restore.py"
	if [ ! -f "$f2 " ]; then
		echo -e "The file $f2 does not exist"
		break
	fi
	mountpoint=$(cat /etc/dnif-bar/config.yaml | grep "backup_mount_point" | awk {'print $2'})

	echo -e "\n[-] Mountpoint is: \n-------------------\n$mountpoint\n"

	echo -e "[-] Recoveries present in the Mountpoint: \n-------------------"
	ls $(cat /etc/dnif-bar/config.yaml | grep "backup_mount_point" | awk {'print $2'})

	recovery=""
	while [[ ! $recovery ]]; do
		echo -e "\n[-] Enter recovery from ['backup','archive']:  \c"
		read -r recovery
		done

	list_scopes=$(ls $(cat /etc/dnif-bar/config.yaml | grep "backup_mount_point" | awk {'print $2'})/$recovery/DNIF/events | sed 's/Scope=//')

	echo -e "\n[-] Scopes presents in $recovery path: \n-------------------\n$list_scopes\n"

	scope=""
	while [[ ! $scope ]]; do
		echo -e "[-] Enter the Scope name as per above mentioned scope list:  \c"
		read -r scope
		done

	echo -e "\n[-] Unique dates present in the backup path: \n-------------------"
	find $(cat /etc/dnif-bar/config.yaml | grep "backup_mount_point" | awk {'print $2'})/$recovery/DNIF/events/Scope\=$scope/ -type f -name "*.zip" | awk -F'/' '{print $(NF)}' | sort | uniq
	day=""
	while [[ ! $day ]]; do
		echo -e "\n[-] Enter the date in following format YYYYMMDD e.g.(20221231):  \c"
		read -r day
		done

	rfi_streams=$(find $(cat /etc/dnif-bar/config.yaml | grep "backup_mount_point" | awk {'print $2'})/$recovery/DNIF/events -type f -name "Day=$day.zip" | grep $scope)

	echo -e "\n[-] Data for $day found in following paths: \n-------------------\n$rfi_streams\n"

	tar -cvzf $day.tar.gz $rfi_streams

	echo -e "\n-------------------\nArchival Process completed for $day, Scope: $scope\n-------------------\n"

fi