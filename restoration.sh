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

	list_scopes=$(ls $(cat /etc/dnif-bar/config.yaml | grep "backup_mount_point" | awk {'print $2'})/backup/DNIF/events | sed 's/Scope=//')

	echo -e "\n[-] Mountpoint is: \n-------------------\n$mountpoint\n"
	echo -e "[-] Scopes presents: \n-------------------\n$list_scopes\n"

	scope=""
	while [[ ! $scope ]]; do
		echo -e "[-] Enter the Scope name as per above mentioned scope list:  \c"
		read -r scope
		done

	day=""
	while [[ ! $day ]]; do
		echo -e "\n[-] Enter the date in following format YYYYMMDD e.g.(20221231):  \c"
		read -r day
		done

	recovery=""
	while [[ ! $recovery ]]; do
		echo -e "\n[-] Enter recovery from ['backup','archive']:  \c"
		read -r recovery
		done

	rfi_streams=$(find $(cat /etc/dnif-bar/config.yaml | grep "backup_mount_point" | awk {'print $2'})/$recovery/DNIF/events -type f -name "Day=$day.zip" | grep $scope | awk -F'/' '{print $(NF-3)}' | sed 's/Stream=//')

	echo -e "\n[-] Data for $day found in following scopes: \n-------------------\n$rfi_streams\n"

	for i in $rfi_streams;
	do
		rm -rf $cwd/restoration.yml
		echo -e "$scope" >> $cwd/restoration.yml
		echo -e	"$i" >> $cwd/restoration.yml
		echo -e	"$day" >> $cwd/restoration.yml
		echo -e	"$recovery" >> $cwd/restoration.yml
		cat $cwd/restoration.yml | python3 /etc/dnif-bar/restore.py
		echo -e "\n-------------------\nRestoration Process completed for $day, Scope: $scope, Stream: $i\n-------------------\n"
		done
fi