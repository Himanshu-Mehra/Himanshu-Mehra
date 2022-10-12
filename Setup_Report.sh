#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo -e "This script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else

	cwd=$(pwd)

	dateis=$(date +%d%m%Y)

	if [[ -e ./Setup_Report_$dateis.log ]]; then
		rm -rf ./Setup_Report_$dateis.log
		touch Setup_Report_$dateis.log
	else
		touch Setup_Report_$dateis.log
	fi

	if [[ -e ./OS_logs_$dateis.tar.gz ]]; then
		rm -rf ./OS_logs_$dateis.tar.gz
	fi

	if [[ -e ./history_$dateis.log ]]; then
		rm -rf ./history_$dateis.log
	fi

	if [[ -e ./top_$dateis.log ]]; then
		rm -rf ./top_$dateis.log
	fi

	if [[ -e ./ps_pcpu_$dateis.log ]]; then
		rm -rf ./ps_pcpu_$dateis.log
	fi

	if [[ -e ./ps_rss_$dateis.log ]]; then
		rm -rf ./ps_rss_$dateis.log
	fi

	if [[ -e ./System_Report_$dateis.tar.gz ]]; then
		rm -rf ./System_Report_$dateis.tar.gz
	fi

	echo -e "\n================================Setup Report=================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ timedatectl\n" >> $cwd/Setup_Report_$dateis.log

	timedatectl >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
	
	if [ -r /etc/os-release ]; then
		os="$(. /etc/os-release && echo -e "$ID")"
	fi
	
	if [[ $os == "ubuntu" ]]; then

		echo -e "$ docker ps -a\n"  >> $cwd/Setup_Report_$dateis.log

		docker ps -a >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "$ docker images --digests\n" >> $cwd/Setup_Report_$dateis.log

		docker images --digests >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		if [[ $(docker ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then
			
			cd /DNIF/LC/ 

			echo -e "$ cat docker-compose.yaml	(CONSOLE)\n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "$ docker-compose logs	(CONSOLE)\n" >> $cwd/Setup_Report_$dateis.log
			docker-compose logs >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=console-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=console-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=console-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=console-v9") hostname' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=console-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
													
		fi

		if [[ $(docker ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
			if [[ -e /DNIF/DL/docker-compose.yaml ]]; then
				
				cd /DNIF/DL

				echo -e "$ cat docker-compose.yaml	(DATANODE)\n" >> $cwd/Setup_Report_$dateis.log
				cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "$ docker-compose logs	(DATANODE)\n" >> $cwd/Setup_Report_$dateis.log
				docker-compose logs >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e '$ docker exec $(docker ps -aqf "name=datanode-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e '$ docker exec $(docker ps -aqf "name=datanode-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "$ systemctl status hadoop-datanode.service | grep -i active\n" >> $cwd/Setup_Report_$dateis.log
				systemctl status hadoop-datanode.service | grep -i active >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "$ systemctl status spark-master.service | grep -i active\n" >> $cwd/Setup_Report_$dateis.log
				systemctl status spark-master.service | grep -i active >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "$ systemctl status spark-slave.service | grep -i active\n" >> $cwd/Setup_Report_$dateis.log
				systemctl status spark-slave.service | grep -i active >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e '$ docker exec $(docker ps -aqf "name=datanode-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e '$ docker exec $(docker ps -aqf "name=datanode-v9") hostname\n' >> $cwd/Setup_Report_$dateis.log
				docker exec $(docker ps -aqf "name=datanode-v9") hostname >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			fi
		fi

		if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
			
			cd /DNIF/

			echo -e "$ cat docker-compose.yaml	(CORE)\n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "$ docker-compose logs	(CORE)\n" >> $cwd/Setup_Report_$dateis.log
			docker-compose logs >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=core-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=datanode-master-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=core-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=datanode-master-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "$ systemctl status hadoop-namenode.service | grep -i active\n" >> $cwd/Setup_Report_$dateis.log
			systemctl status hadoop-namenode.service | grep -i active >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n"	 >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=core-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=datanode-master-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=core-v9") hostname' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=core-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=datanode-master-v9") hostname' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=datanode-master-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log


		fi

		if [[ $(docker ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then
	        
	        cd /DNIF/AD/

	        echo -e "$ cat docker-compose.yaml	(ADAPTER)\n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e "$ docker-compose logs (ADAPTER)\n" >> $cwd/Setup_Report_$dateis.log
	        docker-compose logs >> $cwd/Setup_Report_$dateis.log
	        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e '$ docker exec $(docker ps -aqf "name=adapter-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=adapter-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=adapter-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=adapter-v9") hostname\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=adapter-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

    	fi

    	if [[ $(docker ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then
	        
	        cd /DNIF/PICO/

	        echo -e "$ cat docker-compose.yaml	(PICO)\n" >> $cwd/Setup_Report_$dateis.log
			cat docker-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e "$ docker-compose logs	(PICO)\n" >> $cwd/Setup_Report_$dateis.log
	        docker-compose logs >> $cwd/Setup_Report_$dateis.log
	        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e '$ docker exec $(docker ps -aqf "name=pico-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=pico-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=pico-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ docker exec $(docker ps -aqf "name=pico-v9") hostname\n' >> $cwd/Setup_Report_$dateis.log
			docker exec $(docker ps -aqf "name=pico-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

   		fi

	fi

	if [[ $os == "rhel" ]]; then

		echo -e "$ podman ps -a\n"  >> $cwd/Setup_Report_$dateis.log

		podman ps -a >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		echo -e "$ podman images --digests\n" >> $cwd/Setup_Report_$dateis.log

		podman images --digests >> $cwd/Setup_Report_$dateis.log

		echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		if [[ $(podman ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then
			
			cd /DNIF/LC/ 

			echo -e "$ cat podman-compose.yaml	(CONSOLE)\n" >> $cwd/Setup_Report_$dateis.log
			cat podman-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "$ podman-compose logs	(CONSOLE)\n" >> $cwd/Setup_Report_$dateis.log
			podman-compose logs >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=console-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=console-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=console-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=console-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=console-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=console-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=console-v9") hostname' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=console-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
													
		fi

		if [[ $(podman ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then

			if [[ -e /DNIF/DL/podman-compose.yaml ]]; then
				
				cd /DNIF/DL

				echo -e "$ cat podman-compose.yaml	(DATANODE)\n" >> $cwd/Setup_Report_$dateis.log
				cat podman-compose.yaml >> $cwd/Setup_Report_$dateis.log

				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e "$ podman-compose logs	(DATANODE)\n" >> $cwd/Setup_Report_$dateis.log
				podman-compose logs >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e '$ podman exec $(podman ps -aqf "name=datanode-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
				podman exec $(podman ps -aqf "name=datanode-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e '$ podman exec $(podman ps -aqf "name=datanode-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
				podman exec $(podman ps -aqf "name=datanode-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				if [[ $(podman ps -a --format '{{.Names}}' ) != *"core-v9"* ]]; then
					echo -e "$ systemctl status hadoop-datanode.service | grep -i active\n" >> $cwd/Setup_Report_$dateis.log
					systemctl status hadoop-datanode.service | grep -i active >> $cwd/Setup_Report_$dateis.log
					echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

					echo -e "$ systemctl status spark-master.service | grep -i active\n" >> $cwd/Setup_Report_$dateis.log
					systemctl status spark-master.service | grep -i active >> $cwd/Setup_Report_$dateis.log
					echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

					echo -e "$ systemctl status spark-slave.service | grep -i active\n" >> $cwd/Setup_Report_$dateis.log
					systemctl status spark-slave.service | grep -i active >> $cwd/Setup_Report_$dateis.log
					echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
				fi

				echo -e '$ podman exec $(podman ps -aqf "name=datanode-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
				podman exec $(podman ps -aqf "name=datanode-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

				echo -e '$ podman exec $(podman ps -aqf "name=datanode-v9") hostname\n' >> $cwd/Setup_Report_$dateis.log
				podman exec $(podman ps -aqf "name=datanode-v9") hostname >> $cwd/Setup_Report_$dateis.log
				echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			fi
		fi

		if [[ $(podman ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
			
			cd /DNIF/

			echo -e "$ cat podman-compose.yaml	(CORE)\n" >> $cwd/Setup_Report_$dateis.log
			cat podman-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "$ podman-compose logs	(CORE)\n" >> $cwd/Setup_Report_$dateis.log
			podman-compose logs >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=core-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=core-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=core-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=core-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e "$ systemctl status hadoop-namenode.service | grep -i active\n" >> $cwd/Setup_Report_$dateis.log
			systemctl status hadoop-namenode.service | grep -i active >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n"	 >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=core-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=core-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=core-v9") hostname' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=core-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

		fi

		if [[ $(podman ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then
	        
	        cd /DNIF/AD/

	        echo -e "$ cat podman-compose.yaml	(ADAPTER)\n" >> $cwd/Setup_Report_$dateis.log
			cat podman-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e "$ podman-compose logs (ADAPTER)\n" >> $cwd/Setup_Report_$dateis.log
	        podman-compose logs >> $cwd/Setup_Report_$dateis.log
	        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e '$ podman exec $(podman ps -aqf "name=adapter-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=adapter-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=adapter-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=adapter-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=adapter-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=adapter-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=adapter-v9") hostname\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=adapter-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

    	fi

    	if [[ $(podman ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then
	        
	        cd /DNIF/PICO/

	        echo -e "$ cat podman-compose.yaml	(PICO)\n" >> $cwd/Setup_Report_$dateis.log
			cat podman-compose.yaml >> $cwd/Setup_Report_$dateis.log

			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e "$ podman-compose logs	(PICO)\n" >> $cwd/Setup_Report_$dateis.log
	        podman-compose logs >> $cwd/Setup_Report_$dateis.log
	        echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	        echo -e '$ podman exec $(podman ps -aqf "name=pico-v9") cat /etc/hosts\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") cat /etc/hosts >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=pico-v9") supervisorctl status\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") supervisorctl status >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=pico-v9") env | grep -i proxy\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") env | grep -i proxy >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

			echo -e '$ podman exec $(podman ps -aqf "name=pico-v9") hostname\n' >> $cwd/Setup_Report_$dateis.log
			podman exec $(podman ps -aqf "name=pico-v9") hostname >> $cwd/Setup_Report_$dateis.log
			echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log
		fi
	
	fi

	echo -e "$ uptime -p\n" >> $cwd/Setup_Report_$dateis.log

	uptime -p >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ last reboot\n" >> $cwd/Setup_Report_$dateis.log

	last reboot >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ df -h\n" >> $cwd/Setup_Report_$dateis.log

	df -h >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ free -h\n" >> $cwd/Setup_Report_$dateis.log

	free -h >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ ufw status \n" >> $cwd/Setup_Report_$dateis.log

	ufw status >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ env | grep -i proxy \n" >> $cwd/Setup_Report_$dateis.log

	env | grep -i proxy >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ umask \n" >> $cwd/Setup_Report_$dateis.log

	umask >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ sestatus \n" >> $cwd/Setup_Report_$dateis.log

	if [ ! -f "/usr/sbin/sestatus" ]; then
		echo "policycoreutils is not installed" >> $cwd/Setup_Report_$dateis.log
	else
		sestatus >> $cwd/Setup_Report_$dateis.log
	fi

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ ifconfig \n" >> $cwd/Setup_Report_$dateis.log

	ifconfig >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ lscpu \n" >> $cwd/Setup_Report_$dateis.log

	lscpu >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ nproc \n" >> $cwd/Setup_Report_$dateis.log

	nproc >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ cat /etc/hosts \n" >> $cwd/Setup_Report_$dateis.log

	cat /etc/hosts >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ hostname \n" >> $cwd/Setup_Report_$dateis.log

	hostname >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	echo -e "$ netstat -auntp | grep -i listen \n" >> $cwd/Setup_Report_$dateis.log

	netstat -auntp | grep -i listen >> $cwd/Setup_Report_$dateis.log

	echo -e "\n=============================================================================\n" >> $cwd/Setup_Report_$dateis.log

	cd $cwd
	tar fcz OS_logs_$dateis.tar.gz --absolute-names /var/log/syslog* /var/log/kern.log* /var/log/dmesg*
	
	HISTFILE=~/.bash_history
    set -o history
	history >> history_$dateis.log

	top -c -b -n 5 > top_$dateis.log
	ps aux --sort -pcpu >> ps_pcpu_$dateis.log
	ps aux --sort -rss >> ps_rss_$dateis.log

	tar fcz System_Report_$dateis.tar.gz --absolute-names Setup_Report_$dateis.log OS_logs_$dateis.tar.gz history_$dateis.log top_$dateis.log ps_pcpu_$dateis.log ps_rss_$dateis.log

	if [[ -e ./Setup_Report_$dateis.log ]]; then
		rm -rf ./Setup_Report_$dateis.log
	fi

	if [[ -e ./OS_logs_$dateis.tar.gz ]]; then
		rm -rf ./OS_logs_$dateis.tar.gz
	fi

	if [[ -e ./history_$dateis.log ]]; then
		rm -rf ./history_$dateis.log
	fi

	if [[ -e ./top_$dateis.log ]]; then
		rm -rf ./top_$dateis.log
	fi

	if [[ -e ./ps_pcpu_$dateis.log ]]; then
		rm -rf ./ps_pcpu_$dateis.log
	fi

	if [[ -e ./ps_rss_$dateis.log ]]; then
		rm -rf ./ps_rss_$dateis.log
	fi

fi
