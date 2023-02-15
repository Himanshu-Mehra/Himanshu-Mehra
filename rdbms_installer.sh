#!/bin/bash
set -e

function compose_check() {
	if [ -x "$(command -v docker-compose)" ]; then
		version=$(docker-compose --version |cut -d ' ' -f3 | cut -d ',' -f1)
		if [[ "$version" != "1.23.1" ]]; then
			echo -n "[-] Finding docker-compose installation - found incompatible version"
			echo -e "... \e[0;31m[ERROR] \e[0m\n"
			echo -e "[-] Updating docker-compose\n"
			sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>> /RDBMS/install.log
			sudo chmod +x /usr/local/bin/docker-compose &>> /RDBMS/install.log
			echo -e "[-] Installing docker-compose - ... \e[1;32m[DONE] \e[0m\n"
		else
			echo -e "[-] docker-compose up-to-date\n"
			echo -e "[-] Installing docker-compose - ... \e[1;32m[DONE] \e[0m\n"
		fi
	else
		echo -e "[-] Finding docker-compose installation - ... \e[1;31m[NEGATIVE] \e[0m\n"
		echo -e "[-] Installing docker-compose\n"
		sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>> /RDBMS/install.log
		sudo chmod +x /usr/local/bin/docker-compose&>> /RDBMS/install.log
        	echo -e "[-] Installing docker-compose - ... \e[1;32m[DONE] \e[0m\n"
	fi

}

function compose_check_centos() {
	if [ -x "$(command -v docker-compose)" ]; then
		version=$(docker-compose --version |cut -d ' ' -f3 | cut -d ',' -f1)
		if [[ "$version" != "1.23.1" ]]; then
			echo -n "[-] Finding docker-compose installation - found incompatible version"
			echo -e "... \e[0;31m[ERROR] \e[0m\n"
			echo -e "[-] Updating docker-compose\n"
			sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>> /RDBMS/install.log
			sudo chmod +x /usr/local/bin/docker-compose &>> /RDBMS/install.log
			echo -e "[-] Installing docker-compose - ... \e[1;32m[DONE] \e[0m\n"
		else
			echo -e "[-] docker-compose up-to-date\n"
			echo -e "[-] Installing docker-compose - ... \e[1;32m[DONE] \e[0m\n"
		fi
	else
		echo -e "[-] Finding docker-compose installation - ... \e[1;31m[NEGATIVE] \e[0m\n"
		echo -e "[-] Installing docker-compose\n"
		sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>> /RDBMS/install.log
		sudo chmod +x /usr/local/bin/docker-compose &>> /RDBMS/install.log
		filedc="/usr/bin/docker-compose"
		if [ ! -x "$(command -v docker-compose)" ]; then
			sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose &>> /RDBMS/install.log
		fi
    echo -e "[-] Installing docker-compose - ... \e[1;32m[DONE] \e[0m\n"
	fi

}

function docker_check() {
	echo -e "[-] Finding docker installation\n"
	if [ -x "$(command -v docker)" ]; then
		currentver="$(docker --version |cut -d ' ' -f3 | cut -d ',' -f1)"
        	requiredver="20.10.3"
        	if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then
                	echo -e "[-] docker up-to-date\n"
                	echo -e "[-] Finding docker installation ... \e[1;32m[DONE] \e[0m\n"
        	else
                	echo -n "[-] Finding docker installation - found incompatible version"
                	echo -e "... \e[0;31m[ERROR] \e[0m\n"
                	echo -e "[-] Uninstalling docker\n"
                	sudo apt-get remove docker docker-engine docker.io containerd runc&>> /RDBMS/install.log
                	docker_install
        	fi
	else
        	echo -e "[-] Finding docker installation - ... \e[1;31m[NEGATIVE] \e[0m\n"
        	echo -e "[-] Installing docker\n"
        	docker_install
        	echo -e "[-] Finding docker installation - ... \e[1;32m[DONE] \e[0m\n"
	fi

}

function docker_install() {
	sudo apt-get -y update&>> /RDBMS/install.log
	echo -e "[-] Setting up docker-ce repositories\n"
	sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common&>> /RDBMS/install.log
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -&>> /RDBMS/install.log
	sudo apt-key fingerprint 0EBFCD88&>> /RDBMS/install.log
	sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"&>> /RDBMS/install.log
	sudo apt-get -y update&>> /RDBMS/install.log
	echo -e "[-] Installing docker-ce\n"
	sudo apt-get -y install docker-ce docker-ce-cli containerd.io&>> /RDBMS/install.log
}

function docker_check_centos() {
	echo -e "[-] Finding docker installation\n"
	if [ -x "$(command -v docker)" ]; then
		currentver="$(docker --version |cut -d ' ' -f3 | cut -d ',' -f1)"
        	requiredver="20.10.3"
        	if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then
                	echo -e "[-] docker up-to-date\n"
                	echo -e "[-] Finding docker installation ... \e[1;32m[DONE] \e[0m\n"
        	else
                	echo -n "[-] Finding docker installation - found incompatible version"
                	echo -e "... \e[0;31m[ERROR] \e[0m\n"
                	echo -e "[-] Uninstalling docker\n"
                	sudo yum remove docker \
                    docker-client \
                    docker-client-latest \
                    docker-common \
                    docker-latest \
                    docker-latest-logrotate \
                    docker-logrotate \
                    docker-engine&>> /RDBMS/install.log
                	docker_install_centos
        	fi
	else
        	echo -e "[-] Finding docker installation - ... \e[1;31m[NEGATIVE] \e[0m\n"
        	echo -e "[-] Installing docker\n"
        	docker_install_centos
        	echo -e "[-] Finding docker installation - ... \e[1;32m[DONE] \e[0m\n"
	fi

}

function docker_install_centos() {
	sudo yum install -y yum-utils&>> /RDBMS/install.log
	echo -e "[-] Setting up docker-ce repositories\n"
	sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo&>> /RDBMS/install.log
  echo -e "[centos-extras]
name=Centos extras - $"basearch"
baseurl=http://mirror.centos.org/centos/7/extras/x86_64
enabled=1
gpgcheck=1
gpgkey=http://centos.org/keys/RPM-GPG-KEY-CentOS-7">>/etc/yum.repos.d/docker-ce.repo

	if [ ! -x "$(command -v slirp4netns)" ]; then
		yum install -y slirp4netns&>> /RDBMS/install.log
	fi

	if [ ! -x "$(command -v fuse-overlayfs)" ]; then
		yum install -y fuse-overlayfs&>> /RDBMS/install.log
	fi

	if [ ! -x "$(command -v container-selinux)" ]; then
		yum install -y container-selinux&>> /RDBMS/install.log
	fi
	sudo yum install -y docker-ce docker-ce-cli containerd.io&>> /RDBMS/install.log
	sudo systemctl start docker&>> /RDBMS/install.log
	sudo systemctl enable docker.service&>> /RDBMS/install.log
}

function sysctl_check() {
	count=$(sysctl -n vm.max_map_count)
	if [ "$count" = "262144" ]; then
		echo -e "[-] Fine tuning the operating system\n"
		#ufw -f reset&>> /RDBMS/install.log

	else

		echo -e "#memory & file settings
		fs.file-max=1000000
		vm.overcommit_memory=1
		vm.max_map_count=262144
		#n/w receive buffer
		net.core.rmem_default=33554432
		net.core.rmem_max=33554432" >>/etc/sysctl.conf

		sysctl -p&>> /RDBMS/install.log
		#ufw -f reset&>> /RDBMS/install.log
	fi

}

function set_proxy() {

	echo "HTTP_PROXY="\"$ProxyUrl"\"" >> /etc/environment
	echo "HTTPS_PROXY="\"$ProxyUrl"\"" >> /etc/environment
	echo "https_proxy="\"$ProxyUrl"\"" >> /etc/environment
	echo "http_proxy="\"$ProxyUrl"\"" >> /etc/environment
	
	export HTTP_PROXY=$ProxyUrl 
	export HTTPS_PROXY=$ProxyUrl 
	export https_proxy=$ProxyUrl 
	export http_proxy=$ProxyUrl

}

#echo -e "----------------------------------------------------------------------------------------------------------------------------------"


function podman_compose_check() {
	file="/usr/bin/podman-compose"
	if [ -f "$file" ]; then
		version=$(podman-compose version|grep "podman-composer version" |cut -d " " -f4) 
		if [[ "$version" != "1.0.4" ]]; then
			echo -n "[-] Finding podman-compose installation - found incompatible version"
			echo -e "... \e[0;31m[ERROR] \e[0m\n"
			echo -e "[-] Updating podman-compose\n"
			rm -rf /usr/bin/podman-compose&>> /RDBMS/install.log
			pip3 install --upgrade setuptools&>> /RDBMS/install.log
			pip3 install https://github.com/containers/podman-compose/archive/devel.tar.gz&>> /RDBMS/install.log
			sudo ln -s /usr/local/bin/podman-compose /usr/bin/podman-compose&>> /RDBMS/install.log
			echo -e "[-] Installing podman-compose - ... \e[1;32m[DONE] \e[0m\n"
		else
			echo -e "[-] podman-compose up-to-date\n"
			echo -e "[-] Installing podman-compose - ... \e[1;32m[DONE] \e[0m\n"
		fi
	else
		echo -e "[-] Finding podman-compose installation - ... \e[1;31m[NEGATIVE] \e[0m\n"
		echo -e "[-] Installing podman-compose\n"
		pip3 install --upgrade setuptools&>> /RDBMS/install.log
		pip3 install https://github.com/containers/podman-compose/archive/devel.tar.gz&>> /RDBMS/install.log
		sudo ln -s /usr/local/bin/podman-compose /usr/bin/podman-compose&>> /RDBMS/install.log
        	echo -e "[-] Installing podman-compose - ... \e[1;32m[DONE] \e[0m\n"
	fi

}



function podman_check() {
	echo -e "[-] Finding podman installation\n"
	if [ -x "$(command -v podman)" ]; then
		currentver="$(podman --version|cut -d ' ' -f3)"
		requiredver="2.2.1"
		if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then
			echo -e "[-] podman up-to-date\n"
			echo -e "[-] Finding podman installation ...\e[1;32m[DONE] \e[0m\n"
		else
			echo -n "[-] Finding podman installation - found incompatible version"
                	echo -e "... \e[0;31m[ERROR] \e[0m\n"
                	echo -e "[-] Uninstalling podman\n"
                	podman_install
		fi
	else
		echo -e "[-] Finding podman installation - ... \e[1;31m[NEGATIVE] \e[0m\n"
        	echo -e "[-] Installing podman\n"
        	podman_install
        	echo -e "[-] Finding podman installation - ... \e[1;32m[DONE] \e[0m\n"
	fi


	

}

function podman_install() {
	sudo dnf install -y @container-tools&>> /RDBMS/install.log

}



##########################################################################################################



if [ -r /etc/os-release ]; then
	os="$(. /etc/os-release && echo "$ID")"
fi

tag="v9"
case "${os}" in
	ubuntu)
		if [[ $EUID -ne 0 ]]; then
    echo -e "This script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else

	ARCH=$(uname -m)
	VER=$(lsb_release -rs)
	#tag="v9.0.3" 		# replace tag by the number of release you want
	release=$(lsb_release -ds)
	mkdir -p /RDBMS
	echo -e "\nRDBMS Installer for DNIF $tag\n"
	echo -e "for more information and code visit https://github.com/dnif/installer\n"

	echo -e "++ Checking operating system for compatibility...\n"

	echo -n "Operating system compatibility"
	sleep 2
	if [[ "$VER" = "20.04" ]] && [[ "$ARCH" = "x86_64" ]];  then # replace 20.04 by the number of release you want
		echo -e " ... \e[1;32m[OK] \e[0m"
		echo -n "Architecture compatibility "
		echo -e " ... \e[1;32m[OK] \e[0m\n"
		echo -e "** found $release $ARCH\n"
		echo -e "[-] Checking operating system for compatibility - ... \e[1;32m[DONE] \e[0m\n"
		echo -e "** Please report issues to https://github.com/dnif/installer/issues"
		echo -e "** for more information visit https://docs.dnif.it/v9/docs/high-level-dnif-architecture\n"
		echo -e "-----------------------------------------------------------------------------------------"
		echo -e "[-] Installing the RDBMS \n"
		if [[ "$1" == "proxy" ]]; then
			ProxyUrl=""
			while [[ ! "$ProxyUrl" ]]; do
				echo -e "ENTER Proxy url: \c"
				read -r ProxyUrl
			done
			set_proxy $ProxyUrl
		fi
		docker_check
		compose_check
		sysctl_check
		ufw -f reset&>> /RDBMS/install.log
		if [[ $ProxyUrl ]]; then
			mkdir -p /etc/systemd/system/docker.service.d
			echo -e "[Service]
	Environment=\"HTTPS_PROXY=$ProxyUrl\"">/etc/systemd/system/docker.service.d/http-proxy.conf

			sudo systemctl daemon-reload
			sudo systemctl restart docker
		fi

		echo -e "[-] Pulling docker Image for RDBMS\n"
		docker pull sanket909/personal_repo:v9.2
		docker tag sanket909/personal_repo:v9.2 dnif/rdbms:$tag
		docker rmi sanket909/personal_repo:v9.2 

		sudo echo -e "version: "\'2.0\'"
services:
 ubuntu:
  image: dnif/rdbms:$tag
  network_mode: "\'host\'"
  restart: unless-stopped
  cap_add:
   - NET_ADMIN
  tty: true
  volumes:
   - /RDBMS:/rdbms
  container_name: rdbms-v9">/RDBMS/docker-compose.yaml
		cd /RDBMS
		echo -e "[-] Starting container...\n "
		docker-compose up -d
		echo -e "[-] Starting container ... \e[1;32m[DONE] \e[0m\n"
		docker exec $(docker ps -aqf "name=rdbms-v9") bash -c 'cp -r /dnif/helpers/ /rdbms/'
		docker ps
		echo -e "** Congratulations you have successfully installed the RDBMS\n"
		
		

	else
		echo -e "\e[0;31m[ERROR] \e[0m Operating system is incompatible"
	fi
fi



		;;
	rhel)
		if [[ $EUID -ne 0 ]]; then
    echo -e "This script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else

	ARCH=$(uname -m)
	VER=$(cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//)
	#VER=$(lsb_release -rs)
	#tag="v9.0.3" 		# replace tag by the number of release you want
	release="$(. /etc/os-release && echo "$PRETTY_NAME")"

	mkdir -p /RDBMS
	echo -e "\nRDBMS Installer for DNIF $tag\n"
	echo -e "for more information and code visit https://github.com/dnif/installer\n"

	echo -e "++ Checking operating system for compatibility...\n"

	echo -n "Operating system compatibility "
	sleep 2
	if [[ "$VER" = "8.5" ]] && [[ "$ARCH" = "x86_64" ]];  then # replace 20.04 by the number of release you want
		echo -e " ... \e[1;32m[OK] \e[0m"
		echo -n "Architecture compatibility "
		echo -e " ... \e[1;32m[OK] \e[0m\n"
		echo -e "** found $release $ARCH\n"
		echo -e "[-] Checking operating system for compatibility - ... \e[1;32m[DONE] \e[0m\n"
		echo -e "** Please report issues to https://github.com/dnif/installer/issues"
		echo -e "** for more information visit https://docs.dnif.it/v9/docs/high-level-dnif-architecture\n"
		echo -e "[-] Installing the RDBMS \n"
		if [[ "$1" == "proxy" ]]; then
                        ProxyUrl=""
                        while [[ ! "$ProxyUrl" ]]; do
                                echo -e "ENTER Proxy url: \c"
                                read -r ProxyUrl
                        done
                        set_proxy $ProxyUrl
                fi
		podman_check
		podman_compose_check
		sysctl_check
		setenforce 0&>> /RDBMS/install.log
		file="/usr/bin/wget"
                if [ ! -f "$file " ]; then
			dnf install -y wget&>> /RDBMS/install.log
                        dnf install -y zip&>> /RDBMS/install.log
                fi
		
		if [[ $ProxyUrl ]]; then
                        mkdir -p /etc/systemd/system/docker.service.d
                        echo -e "[Service]
        Environment=\"HTTPS_PROXY=$ProxyUrl\"">/etc/systemd/system/docker.service.d/http-proxy.conf

                        sudo systemctl daemon-reload
                        sudo systemctl restart podman
                fi
		echo -e "[-] Pulling docker Image for RDBMS\n"
		podman pull sanket909/personal_repo:v9.2
		podman tag sanket909/personal_repo:v9.2 dnif/rdbms:$tag
		podman rmi sanket909/personal_repo:v9.2

		sudo echo -e "version: "\'2.0\'"
services:
 ubuntu:
  image: dnif/rdbms:$tag
  network_mode: "\'host\'"
  restart: unless-stopped
  cap_add:
   - NET_ADMIN
  tty: true
  volumes:
   - /RDBMS:/rdbms
  container_name: rdbms-v9">/RDBMS/podman-compose.yaml

		echo -e "[-] Starting container... \n"
		cd /RDBMS
		podman-compose up -d
		echo -e "[-] Starting container ... \e[1;32m[DONE] \e[0m\n"
		podman exec $(podman ps -aqf "name=rdbms-v9") bash -c 'cp -r /dnif/helpers/ /rdbms/'
		podman ps
		echo -e "** Congratulations you have successfully installed the RDBMS\n"


	else
		echo -e "\n\e[0;31m[ERROR] \e[0m Operating system is incompatible"
	fi
fi
		;;

	centos)
		if [[ $EUID -ne 0 ]]; then
    echo -e "This script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else

	ARCH=$(uname -m)
	VER=$(cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//)
	#VER=$(lsb_release -rs)
	#tag="v9.0.3" 		# replace tag by the number of release you want
	release="$(. /etc/os-release && echo "$PRETTY_NAME")"

	mkdir -p /RDBMS
	echo -e "\nRDBMS Installer for DNIF $tag\n"
	echo -e "for more information and code visit https://github.com/dnif/installer\n"

	echo -e "++ Checking operating system for compatibility...\n"

	echo -n "Operating system compatibility"
	sleep 2
	if [[ "$VER" = "7.9.2009" ]] && [[ "$ARCH" = "x86_64" ]];  then # replace 20.04 by the number of release you want
		echo -e " ... \e[1;32m[OK] \e[0m"
		echo -n "Architecture compatibility "
		echo -e " ... \e[1;32m[OK] \e[0m\n"
		echo -e "** found $release $ARCH\n"
		echo -e "[-] Checking operating system for compatibility - ... \e[1;32m[DONE] \e[0m\n"
		echo -e "** Please report issues to https://github.com/dnif/installer/issues"
		echo -e "** for more information visit https://docs.dnif.it/v9/docs/high-level-dnif-architecture\n"
		echo -e "-----------------------------------------------------------------------------------------"
		echo -e "[-] Installing the RDBMS \n"
		sudo mkdir -p /RDBMS

		if [[ "$1" == "proxy" ]]; then
			ProxyUrl=""
			while [[ ! "$ProxyUrl" ]]; do
				echo -e "ENTER Proxy url: \c"
				read -r ProxyUrl
			done
			set_proxy $ProxyUrl
		fi
		docker_check_centos
		compose_check_centos
		sysctl_check
		setenforce 0&>> /RDBMS/install.log
		if [[ $ProxyUrl ]]; then
			mkdir -p /etc/systemd/system/docker.service.d
			echo -e "[Service]
	Environment=\"HTTPS_PROXY=$ProxyUrl\"">/etc/systemd/system/docker.service.d/http-proxy.conf

			sudo systemctl daemon-reload
			sudo systemctl restart docker
		fi
		file="/usr/bin/wget"
                if [ ! -f "$file " ]; then
			yum install -y wget&>> /RDBMS/install.log
                        yum install -y zip&>> /RDBMS/install.log
                fi
		echo -e "[-] Pulling docker Image for RDBMS\n"
		docker pull sanket909/personal_repo:v9.2
		docker tag sanket909/personal_repo:v9.2 dnif/rdbms:$tag
		docker rmi sanket909/personal_repo:v9.2
		
		sudo echo -e "version: "\'2.0\'"
services:
 ubuntu:
  image: dnif/rdbms:$tag
  network_mode: "\'host\'"
  restart: unless-stopped
  cap_add:
   - NET_ADMIN
  tty: true
  volumes:
   - /RDBMS:/rdbms
  container_name: rdbms-v9">/RDBMS/docker-compose.yaml
		cd /RDBMS
		echo -e "[-] Starting container...\n "
		docker-compose up -d
		echo -e "[-] Starting container ... \e[1;32m[DONE] \e[0m\n"
		docker exec $(docker ps -aqf "name=rdbms-v9") bash -c 'cp -r /dnif/helpers/ /rdbms/'
		docker ps
		echo -e "** Congratulations you have successfully installed the RDBMS\n"		
		

	else
		echo -e "\e[0;31m[ERROR] \e[0m Operating system is incompatible"
	fi
fi

		;;
	esac
