#!/bin/bash
set -e

tag="v9.4.1"

upgrade_docker_container () {
	if [[ "$1" == "core-v9" ]]; then
        echo -e "\n[-] Bringing down the Docker Compose environment of $1 $2 & datanode-master-v9 $2\n"
		if [ -e /DNIF/DL/docker-compose.yaml ]; then
			cd /DNIF/DL/
			docker-compose down
		fi
		cd /DNIF
		docker-compose down
		echo -e "\n[-] Docker container stopped and removed\n"
		docker ps -a
		echo -e "\n[-] Checking Docker Image for CORE & DATANODE $tag\n"
		coimage=$(echo "$(docker images | grep 'dnif/core' | grep "$tag")")
		if [ -n "$coimage" ]; then
			echo -e "[-] Docker Image core:$tag already exists."
			echo -e "$coimage"
		else
			echo -e "[-] Docker Image core:$tag does not exist. Pulling the image..."
			docker pull docker.io/dnif/core:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$coimage"
		fi
		dnimage=$(echo "$(docker images | grep 'dnif/datanode' | grep "$tag")")
		if [ -n "$dnimage" ]; then
			echo -e "\n[-] Docker Image datanode:$tag already exists."
			echo -e "$dnimage"
		else
			echo -e "[-] Docker Image datanode:$tag does not exist. Pulling the image..."
			docker pull docker.io/dnif/datanode:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$dnimage"
		fi
	elif [[ "$1" == "console-v9" ]]; then
		echo -e "\n[-] Bringing down the Docker Compose environment of $1 $2\n"
		cd /DNIF/LC
		docker-compose down
		echo -e "\n[-] Docker container stopped and removed\n"
		docker ps -a
		echo -e "\n[-] Checking Docker Image for CONSOLE $tag\n"
		lcimage=$(echo "$(docker images | grep 'dnif/console' | grep "$tag")")
		if [ -n "$lcimage" ]; then
			echo -e "[-] Docker Image console:$tag already exists."
			echo -e "$lcimage"
		else
			echo -e "[-] Docker Image console:$tag does not exist. Pulling the image..."
			docker pull docker.io/dnif/console:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$lcimage"
		fi
	elif [[ "$1" == "datanode-v9" ]]; then
		echo -e "\n[-] Bringing down the Docker Compose environment of $1 $2\n"
		cd /DNIF/DL
		docker-compose down
		echo -e "\n[-] Docker container stopped and removed\n"
		docker ps -a
		echo -e "\n[-] Checking Docker Image for DATANODE $tag\n"
		dnimage=$(echo "$(docker images | grep 'dnif/datanode' | grep "$tag")")
		if [ -n "$dnimage" ]; then
			echo -e "[-] Docker Image datanode:$tag already exists."
			echo -e "$dnimage"
		else
			echo -e "[-] Docker Image datanode:$tag does not exist. Pulling the image..."
			docker pull docker.io/dnif/datanode:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$dnimage"
		fi
	elif [[ "$1" == "adapter-v9" ]]; then
		echo -e "\n[-] Bringing down the Docker Compose environment of $1 $2\n"
		cd /DNIF/AD
		docker-compose down
		echo -e "\n[-] Docker container stopped and removed\n"
		docker ps -a
		echo -e "\n[-] Checking Docker Image for ADAPTER $tag\n"
		adimage=$(echo "$(docker images | grep 'dnif/adapter' | grep "$tag")")
		if [ -n "$adimage" ]; then
			echo -e "[-] Docker Image adapter:$tag already exists."
			echo -e "$adimage"
		else
			echo -e "[-] Docker Image adapter:$tag does not exist. Pulling the image..."
			docker pull docker.io/dnif/adapter:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$adimage"
		fi
	elif [[ "$1" == "pico-v9" ]]; then
		echo -e "\n[-] Bringing down the Docker Compose environment of $1 $2\n"
		cd /DNIF/PICO
		docker-compose down
		echo -e "\n[-] Docker container stopped and removed\n"
		docker ps -a
		echo -e "\n[-] Checking Docker Image for PICO $tag\n"
		pcimage=$(echo "$(docker images | grep 'dnif/pico' | grep "$tag")")
		if [ -n "$pcimage" ]; then
			echo -e "[-] Docker Image pico:$tag already exists."
			echo -e "$pcimage"
		else
			echo -e "[-] Docker Image pico:$tag does not exist. Pulling the image..."
			docker pull docker.io/dnif/pico:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$pcimage"
		fi
	fi
}


upgrade_podman_container () {

	if [[ "$1" == "core-v9" ]]; then
		echo -e "\n[-] Bringing down the Podman Compose environment of datanode-master-v9 $2\n"
		cd /DNIF/DL
		podman-compose down
		podman ps -a
		echo -e "\n[-] Bringing down the Podman Compose environment of $1 $2\n"
		cd /DNIF
		podman-compose down
		echo -e "[-] Podman container stopped and removed\n"
		podman ps -a
		echo -e "\n[-] Checking Docker Image for CORE & DATANODE $tag\n"
		coimage=$(echo "$(podman images | grep 'dnif/core' | grep "$tag")")
		if [ -n "$coimage" ]; then
			echo -e "[-] Docker Image core:$tag already exists."
			echo -e "$coimage"
		else
			echo -e "[-] Docker Image core:$tag does not exist. Pulling the image..."
			podman pull docker.io/dnif/core:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$coimage"
		fi
		dnimage=$(echo "$(podman images | grep 'dnif/datanode' | grep "$tag")")
		if [ -n "$dnimage" ]; then
			echo -e "\n[-] Docker Image datanode:$tag already exists."
			echo -e "$dnimage"
		else
			echo -e "[-] Docker Image datanode:$tag does not exist. Pulling the image..."
			podman pull docker.io/dnif/datanode:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$dnimage"
		fi
	elif [[ "$1" == "console-v9" ]]; then
		echo -e "\n[-] Bringing down the Podman Compose environment of $1 $2\n"
		cd /DNIF/LC
		podman-compose down
		echo -e "[-] Podman container stopped and removed\n"
		podman ps -a
		echo -e "\n[-] Checking Docker Image for CONSOLE $tag\n"
		lcimage=$(echo "$(podman images | grep 'dnif/console' | grep "$tag")")
		if [ -n "$lcimage" ]; then
			echo -e "[-] Docker Image console:$tag already exists."
			echo -e "$lcimage"
		else
			echo -e "[-] Docker Image console:$tag does not exist. Pulling the image..."
			podman pull docker.io/dnif/console:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$lcimage"
		fi
	elif [[ "$1" == "datanode-v9" ]]; then
		echo -e "\n[-] Bringing down the Podman Compose environment of $1 $2\n"
		cd /DNIF/DL
		podman-compose down
		echo -e "[-] Podman container stopped and removed\n"
		podman ps -a
		echo -e "\n[-] Checking Docker Image for DATANODE $tag\n"
		dnimage=$(echo "$(podman images | grep 'dnif/datanode' | grep "$tag")")
		if [ -n "$dnimage" ]; then
			echo -e "[-] Docker Image datanode:$tag already exists."
			echo -e "$dnimage"
		else
			echo -e "[-] Docker Image datanode:$tag does not exist. Pulling the image..."
			podman pull docker.io/dnif/datanode:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$dnimage"
		fi
	elif [[ "$1" == "adapter-v9" ]]; then
		echo -e "\n[-] Bringing down the Podman Compose environment of $1 $2\n"
		cd /DNIF/AD
		podman-compose down
		echo -e "[-] Podman container stopped and removed\n"
		podman ps -a
		echo -e "\n[-] Checking Docker Image for ADAPTER $tag\n"
		adimage=$(echo "$(podman images | grep 'dnif/adapter' | grep "$tag")")
		if [ -n "$adimage" ]; then
			echo -e "[-] Docker Image adapter:$tag already exists."
			echo -e "$adimage"
		else
			echo -e "[-] Docker Image adapter:$tag does not exist. Pulling the image..."
			podman pull docker.io/dnif/adapter:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$adimage"
		fi
	elif [[ "$1" == "pico-v9" ]]; then
		echo -e "\n[-] Bringing down the Podman Compose environment of $1 $2\n"
		cd /DNIF/PICO
		podman-compose down
		echo -e "[-] Podman container stopped and removed\n"
		podman ps -a
		echo -e "\n[-] Checking Docker Image for PICO $tag\n"
		pcimage=$(echo "$(podman images | grep 'dnif/pico' | grep "$tag")")
		if [ -n "$pcimage" ]; then
			echo -e "[-] Docker Image pico:$tag already exists."
			echo -e "$pcimage"
		else
			echo -e "[-] Docker Image pico:$tag does not exist. Pulling the image..."
			podman pull docker.io/dnif/pico:$tag
			echo -e "[-] Image pull completed..!"
			echo -e "$pcimage"
		fi
	fi	
}


if [ -r /etc/os-release ]; then
	os="$(. /etc/os-release && echo "$ID")"
fi

case "${os}" in
	ubuntu|centos)
		container_list=( "pico-v9" "adapter-v9" "datanode-v9" "console-v9" "core-v9" )
		echo -e "[-] Finding docker container\n"
		for container_name in "${container_list[@]}"
		do
			if [ "$(docker ps -q -f status=running -f name=$container_name)" ]; then
				echo -e "[-] Found $container_name docker container\n"
				echo -e "[-] Checking for current running version\n"
				current_ver="$(docker ps  -f status=running -f name=$container_name|awk 'NR > 1 {print $2; exit}'|cut -d ":" -f2)"
				echo -e "[-] Found $container_name current version $current_ver\n"
				docker ps -a
				upgrade_docker_container $container_name $current_ver
			fi
		done	
		;;
	rhel)
		container_list=( "pico-v9" "adapter-v9" "datanode-v9" "console-v9" "core-v9" )
		echo -e "[-] Finding podman container\n"
		for container_name in "${container_list[@]}"
		do
			if [ "$(podman ps -q -f status=running -f name=$container_name)" ]; then
				echo -e "[-] Found $container_name podman container\n"
				echo -e "[-] Checking for current running version\n"
				current_ver="$(podman ps  -f status=running -f name=$container_name|awk 'NR > 1 {print $2; exit}'|cut -d ":" -f2)"
				echo -e "[-] Found $container_name current version $current_ver\n"
				podman ps -a
				upgrade_podman_container $container_name $current_ver
			fi
		done
		;;

	esac
