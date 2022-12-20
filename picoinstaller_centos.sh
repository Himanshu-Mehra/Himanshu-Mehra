#!/bin/bash
set -e

function compose_check() {
	if [ -x "$(command -v docker-compose)" ]; then
		version=$(docker-compose --version |cut -d ' ' -f3 | cut -d ',' -f1)
		if [[ "$version" != "1.23.1" ]]; then
			echo -n "[-] Finding docker-compose installation - found incompatible version"
			echo -e "... \e[0;31m[ERROR] \e[0m\n"
			echo -e "[-] Updating docker-compose\n"
			sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>> /DNIF/install.log
			sudo chmod +x /usr/local/bin/docker-compose &>> /DNIF/install.log
			echo -e "[-] Installing docker-compose - ... \e[1;32m[DONE] \e[0m\n"
		else
			echo -e "[-] docker-compose up-to-date\n"
			echo -e "[-] Installing docker-compose - ... \e[1;32m[DONE] \e[0m\n"
		fi
	else
		echo -e "[-] Finding docker-compose installation - ... \e[1;31m[NEGATIVE] \e[0m\n"
		echo -e "[-] Installing docker-compose\n"
		sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>> /DNIF/install.log
		sudo chmod +x /usr/local/bin/docker-compose&>> /DNIF/install.log
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
			sudo curl -k -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>> /DNIF/install.log
			sudo chmod +x /usr/local/bin/docker-compose &>> /DNIF/install.log
			sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose &>> /DNIF/install.log
			echo -e "[-] Installing docker-compose - ... \e[1;32m[DONE] \e[0m\n"
		else
			echo -e "[-] docker-compose up-to-date\n"
			echo -e "[-] Installing docker-compose - ... \e[1;32m[DONE] \e[0m\n"
		fi
	else
		echo -e "[-] Finding docker-compose installation - ... \e[1;31m[NEGATIVE] \e[0m\n"
		echo -e "[-] Installing docker-compose\n"
		sudo curl -k -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>> /DNIF/install.log
		sudo chmod +x /usr/local/bin/docker-compose &>> /DNIF/install.log
		filedc="/usr/bin/docker-compose"
		if [ ! -x "$(command -v docker-compose)" ]; then
			sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose &>> /DNIF/install.log
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
                	sudo apt-get remove docker docker-engine docker.io containerd runc&>> /DNIF/install.log
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
	sudo apt-get -y update&>> /DNIF/install.log
	echo -e "[-] Setting up docker-ce repositories\n"
	sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common&>> /DNIF/install.log
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -&>> /DNIF/install.log
	sudo apt-key fingerprint 0EBFCD88&>> /DNIF/install.log
	sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"&>> /DNIF/install.log
	sudo apt-get -y update&>> /DNIF/install.log
	echo -e "[-] Installing docker-ce\n"
	sudo apt-get -y install docker-ce docker-ce-cli containerd.io&>> /DNIF/install.log
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
                    docker-engine&>> /DNIF/install.log
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
	sudo yum install -y yum-utils&>> /DNIF/install.log
	echo -e "[-] Setting up docker-ce repositories\n"
	sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo&>> /DNIF/install.log
  echo -e "[centos-extras]
name=Centos extras - $"basearch"
baseurl=http://mirror.centos.org/centos/7/extras/x86_64
enabled=1
gpgcheck=1
gpgkey=http://centos.org/keys/RPM-GPG-KEY-CentOS-7">>/etc/yum.repos.d/docker-ce.repo

	if [ ! -x "$(command -v slirp4netns)" ]; then
		yum install -y slirp4netns&>> /DNIF/install.log
	fi

	if [ ! -x "$(command -v fuse-overlayfs)" ]; then
		yum install -y fuse-overlayfs&>> /DNIF/install.log
	fi

	if [ ! -x "$(command -v container-selinux)" ]; then
		yum install -y container-selinux&>> /DNIF/install.log
	fi
	sudo yum install -y docker-ce docker-ce-cli containerd.io&>> /DNIF/install.log
	sudo systemctl start docker&>> /DNIF/install.log
	sudo systemctl enable docker.service&>> /DNIF/install.log
}

function sysctl_check() {
	count=$(sysctl -n vm.max_map_count)
	if [ "$count" = "262144" ]; then
		echo -e "[-] Fine tuning the operating system\n"
		#ufw -f reset&>> /DNIF/install.log

	else

		echo -e "#memory & file settings
		fs.file-max=1000000
		vm.overcommit_memory=1
		vm.max_map_count=262144
		#n/w receive buffer
		net.core.rmem_default=33554432
		net.core.rmem_max=33554432" >>/etc/sysctl.conf

		sysctl -p&>> /DNIF/install.log
		#ufw -f reset&>> /DNIF/install.log
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
			rm -rf /usr/bin/podman-compose&>> /DNIF/install.log
			pip3 install --upgrade setuptools&>> /DNIF/install.log
			pip3 install https://github.com/containers/podman-compose/archive/devel.tar.gz&>> /DNIF/install.log
			sudo ln -s /usr/local/bin/podman-compose /usr/bin/podman-compose&>> /DNIF/install.log
			echo -e "[-] Installing podman-compose - ... \e[1;32m[DONE] \e[0m\n"
		else
			echo -e "[-] podman-compose up-to-date\n"
			echo -e "[-] Installing podman-compose - ... \e[1;32m[DONE] \e[0m\n"
		fi
	else
		echo -e "[-] Finding podman-compose installation - ... \e[1;31m[NEGATIVE] \e[0m\n"
		echo -e "[-] Installing podman-compose\n"
		pip3 install --upgrade setuptools&>> /DNIF/install.log
		pip3 install https://github.com/containers/podman-compose/archive/devel.tar.gz&>> /DNIF/install.log
		sudo ln -s /usr/local/bin/podman-compose /usr/bin/podman-compose&>> /DNIF/install.log
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
	sudo dnf install -y @container-tools&>> /DNIF/install.log

}







if [ -r /etc/os-release ]; then
	os="$(. /etc/os-release && echo "$ID")"
fi

tag="v9.2.0"
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
	mkdir -p /DNIF
	echo -e "\nDNIF Installer for $tag\n"
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
		echo -e "[-] Installing the PICO \n"
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
		ufw -f reset&>> /DNIF/install.log
		if [[ $ProxyUrl ]]; then
			mkdir -p /etc/systemd/system/docker.service.d
			echo -e "[Service]
	Environment=\"HTTPS_PROXY=$ProxyUrl\"">/etc/systemd/system/docker.service.d/http-proxy.conf

			sudo systemctl daemon-reload
			sudo systemctl restart docker
		fi

		echo -e "[-] Pulling docker Image for PICO\n"
		docker pull dnif/pico:$tag
		COREIP=""
		while [[ ! $COREIP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
			echo -e "ENTER CORE IP: \c"
			read -r COREIP
		done
		cd /
		sudo mkdir -p /DNIF
		sudo mkdir -p /DNIF/PICO
		sudo echo -e "version: "\'2.0\'"
services:
 pico:
  image: dnif/pico:$tag
  network_mode: "\'host\'"
  restart: unless-stopped
  cap_add:
   - NET_ADMIN
  environment:
   - "\'CORE_IP="$COREIP"\'"
   - "\'PROXY="$ProxyUrl"\'"
  volumes:
   - /DNIF/PICO:/dnif
   - /DNIF/backup/pc:/backup
  container_name: pico-v9">/DNIF/PICO/docker-compose.yaml
		cd /DNIF/PICO || exit
		IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
		echo -e "[-] Starting container...\n "
		docker-compose up -d
		echo -e "[-] Starting container ... \e[1;32m[DONE] \e[0m\n"
		docker ps
		echo -e "** Congratulations you have successfully installed the PICO\n"
		echo -e "**   Activate the PICO ($IP) from the components page\n"
		
		

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

	mkdir -p /DNIF
	echo -e "\nDNIF Installer for $tag\n"
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
		echo -e "[-] Installing the PICO \n"
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
		setenforce 0&>> /DNIF/install.log
		mkdir -p /DNIF/PICO&>> /DNIF/install.log
		file="/usr/bin/wget"
                if [ ! -f "$file " ]; then
			dnf install -y wget&>> /DNIF/install.log
                        dnf install -y zip&>> /DNIF/install.log
                fi

		
		mkdir -p /DNIF/backup/pc&>> /DNIF/install.log
		if [[ $ProxyUrl ]]; then
                        mkdir -p /etc/systemd/system/docker.service.d
                        echo -e "[Service]
        Environment=\"HTTPS_PROXY=$ProxyUrl\"">/etc/systemd/system/docker.service.d/http-proxy.conf

                        sudo systemctl daemon-reload
                        sudo systemctl restart podman
                fi
		echo -e "[-] Pulling docker Image for PICO\n"
		sudo podman pull docker.io/dnif/pico:$tag
		COREIP=""
		while [[ ! $COREIP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
			echo -e "ENTER CORE IP: \c"
			read -r COREIP
		done
		sudo echo -e "version: "\'2.0\'"
services:
 pico:
  image: docker.io/dnif/pico:$tag
  network_mode: "\'host\'"
  restart: unless-stopped
  cap_add:
   - NET_ADMIN
  environment:
   - "\'PROXY="$ProxyUrl"\'"
   - "\'CORE_IP="$COREIP"\'"
  volumes:
   - /DNIF/PICO:/dnif
   - /DNIF/backup/pc:/backup
  container_name: pico-v9">/DNIF/PICO/podman-compose.yaml

		echo -e "[-] Starting container... \n"
		cd /DNIF/PICO
		podman-compose up -d
		echo -e "** Congratulations you have successfully installed the PICO\n"
		echo -e "**   Activate the PICO ($IP) from the components page\n"


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

	mkdir -p /DNIF
	echo -e "\nDNIF Installer for $tag\n"
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
		echo -e "[-] Installing the PICO \n"
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
		setenforce 0&>> /DNIF/install.log
		if [[ $ProxyUrl ]]; then
			mkdir -p /etc/systemd/system/docker.service.d
			echo -e "[Service]
	Environment=\"HTTPS_PROXY=$ProxyUrl\"">/etc/systemd/system/docker.service.d/http-proxy.conf

			sudo systemctl daemon-reload
			sudo systemctl restart docker
		fi
		file="/usr/bin/wget"
                if [ ! -f "$file " ]; then
			yum install -y wget&>> /DNIF/install.log
                        yum install -y zip&>> /DNIF/install.log
                fi
		echo -e "[-] Pulling docker Image for PICO\n"
		docker pull docker.io/dnif/pico:$tag
		COREIP=""
		while [[ ! $COREIP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
			echo -e "ENTER CORE IP: \c"
			read -r COREIP
		done
		cd /
		sudo mkdir -p /DNIF/PICO
		mkdir -p /DNIF/backup/pc&>> /DNIF/install.log
		sudo echo -e "version: "\'2.0\'"
services:
 pico:
  image: docker.io/dnif/pico:$tag
  network_mode: "\'host\'"
  restart: unless-stopped
  cap_add:
   - NET_ADMIN
  environment:
   - "\'CORE_IP="$COREIP"\'"
   - "\'PROXY="$ProxyUrl"\'"
  volumes:
   - /DNIF/PICO:/dnif
   - /DNIF/backup/pc:/backup
  container_name: pico-v9">/DNIF/PICO/docker-compose.yaml
		cd /DNIF/PICO
		IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
		echo -e "[-] Starting container...\n "
		docker-compose up -d
		echo -e "[-] Starting container ... \e[1;32m[DONE] \e[0m\n"
		docker ps
		echo -e "** Congratulations you have successfully installed the PICO\n"
		echo -e "**   Activate the PICO ($IP) from the components page\n"
		
		

	else
		echo -e "\e[0;31m[ERROR] \e[0m Operating system is incompatible"
	fi
fi

		;;
	esac
