#!/bin/bash
if [[ $EUID -ne 0 ]]; then
	echo -e "This script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else
	cwd=$(pwd)
	f1="/etc/dnif-bar/config.yaml"
	if [ ! -f $f1 ]; then
		echo -e "The file $f1 does not exist"
		exit 1
	else

		mountpoint=$(cat /etc/dnif-bar/config.yaml | grep "backup_mount_point" | awk {'print $2'})

		echo -e "\n[-] Mountpoint is: \n-------------------\n$mountpoint\n"

		echo -e "[-] Recoveries present in the Mountpoint: \n-------------------"
		ls $(cat /etc/dnif-bar/config.yaml | grep "backup_mount_point" | awk {'print $2'})

		recovery=""
		while [[ ! $recovery ]]; do
			echo -e "\n[-] Enter recovery from ['backup','archive']:  \c"
			read -r recovery
			done

		list_scopes=$(ls $mountpoint/$recovery/DNIF/events | sed 's/Scope=//')

		echo -e "\n[-] Scopes presents in $recovery path: \n-------------------\n$list_scopes\n"

		scope=""
		while [[ ! $scope ]]; do
			echo -e "[-] Enter the Scope name as per above mentioned scope list:  \c"
			read -r scope
			done

		echo -e "\n[-] Unique dates present in the $scope $recovery path: \n-------------------"
		allzip=$(find $mountpoint/$recovery/DNIF/events/Scope\=$scope/ -type f -name "*.zip" | awk -F'/' '{print $(NF)}' | sort | uniq)
		echo -e "$allzip"

		echo -e "\n[-] Data can be archived in 2 ways:"
		echo -e "    [1] All the Streams Data in $scope for a particular day"
		echo -e "    [2] All the Streams Data in $scope for all the days\n-------------------"

		if [ ! -e "$cwd/tar_md5sum.log" ]; then
			touch $cwd/tar_md5sum.log
		fi

		OPT=""
		while [[ ! $OPT =~ ^[1-2] ]]; do
			echo -e "Pick the number corresponding to the option (1 - 2):  \c"
			read -r OPT
			done
		case "${OPT^^}" in
			1)
		    	day=""

				while [[ ! $day ]]; do
					echo -e "\n[-] Enter the date in following format YYYYMMDD e.g.(20221231):  \c"
					read -r day
					done

				cd $mountpoint
				dfi_streams=$(find ./$recovery/DNIF/events/Scope\=$scope/ -type f -name "Day=$day.zip")

				echo -e "\n[-] Data for $day found in following paths: \n-------------------\n$dfi_streams\n"

				sizecal=$(echo "$(expr $(du -s $dfi_streams | awk '{sum+=$1} END {print sum}') / 1024) MB")

				echo -e "[-] Total Size of the files: \n-------------------\n$sizecal\n"

				echo -e "[-] Creating tar file of the files found: \n-------------------"

				tar -cvzf $cwd/$day"_"$scope.tar.gz $dfi_streams

				echo -e "\n[-] Archival Process completed of $recovery for $day, Scope: $scope, Created file: $day"_"$scope.tar.gz\n-------------------\nFile size: $(du -sh $cwd/$day"_"$scope.tar.gz)\n"

				echo -e "MD5SUM : \c" >> $cwd/$day"_"$scope"_md5sum".txt
				md5sum $cwd/$day"_"$scope.tar.gz >> $cwd/$day"_"$scope"_md5sum".txt

				echo -e "MD5SUM : \c" >> $cwd/tar_md5sum.log
				md5sum $cwd/$day"_"$scope.tar.gz >> $cwd/tar_md5sum.log
		    	;;
		  	2)
				azday=$(echo -e "$allzip" | sed 's/Day=//; s/\.zip$//')
				bookmark=$(cat $cwd/tar_md5sum.log | awk {'print $(NF)'} | sed 's#.*/\([^/]*\)\.tar\.gz#\1#')

				cd $mountpoint
				for day in $azday;
				do
					
					if [[ "$bookmark" == *"$day"_"$scope"* ]]; then
						echo "[-] Backup already taken for $day"_"$scope"
					else
						dfi_streams=$(find ./$recovery/DNIF/events/Scope\=$scope/ -type f -name "Day=$day.zip")

						echo -e "\n[-] Data for $day found in following paths: \n-------------------\n$dfi_streams\n"

						sizecal=$(echo "$(expr $(du -s $dfi_streams | awk '{sum+=$1} END {print sum}') / 1024) MB")

						echo -e "[-] Total Size of the files: \n-------------------\n$sizecal\n"

						echo -e "[-] Creating tar file of the files found: \n-------------------"

						tar -cvzf $cwd/$day"_"$scope.tar.gz $dfi_streams

						echo -e "\n[-] Archival Process completed of $recovery for $day, Scope: $scope, Created file: $day"_"$scope.tar.gz\n-------------------\nFile size: $(du -sh $cwd/$day"_"$scope.tar.gz)\n"

						echo -e "MD5SUM : \c" >> $cwd/$day"_"$scope"_md5sum".txt
						md5sum $cwd/$day"_"$scope.tar.gz >> $cwd/$day"_"$scope"_md5sum".txt

						echo -e "MD5SUM : \c" >> $cwd/tar_md5sum.log
						md5sum $cwd/$day"_"$scope.tar.gz >> $cwd/tar_md5sum.log
					fi
						
				done

				echo -e "\n[-] Archival Process completed of $recovery for All days, Scope: $scope"
				;;
		esac
	fi

fi