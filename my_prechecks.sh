#!/bin/bash

set -e

#-------------------------------------------------Reading inputs-------------------------------------------------------

echo -e "* Select the DNIF component you would like to check Prerequisites for:"
echo -e "    [1] Core (CO)"
echo -e "    [2] Local Console (LC)"
echo -e "    [3] Datanode (DN)"
echo -e "    [4] Adapter (AD)"
echo -e "    [5] Pico\n"

COMPONENT=""
while [[ ! $COMPONENT =~ ^[1-5] ]]; do
	echo -e "Pick the number corresponding to the component (1 - 5):  \c"
        read -r COMPONENT
done

echo -e "\n* Select the Deployment Environment:"
echo -e "    [1] Test Environment"
echo -e "    [2] Production Environment\n"

ENVIR=""
while [[ ! $ENVIR =~ ^[1-2] ]]; do
	echo -e "Pick the number corresponding to the Environemt (1 - 5):  \c"
    read -r ENVIR
done

echo -e "\n-----------------------------------Enter Customer Name----------------------------"
echo -e "Enter the Customer Name :  \c"
read -r cust_name

#----------------------------------------------------Functions----------------------------------------------------------


# ip_connectivity() function is for testing the connectivty using ping command
ip_connectivity() {
	
	echo -e "\nTesting connection with ${1}"

	ip_addresses=$(cat components.txt | grep -i ${1} | awk '{ print $2 }')	
	for i in $ip_addresses;
	do
		ping -c 2 $i &> /dev/null &&
    			printf "Connectivity with $i.......................................Passed \n" ||
    			printf "Connectivity with $i.......................................Failed \n"
	done
	
	hostname=$(cat components.txt | grep -i ${1} | awk '{ print $3 }')
	for j in $hostname;
	do
		hip=$(ping -c 1 $j | grep -i "bytes of data" | awk '{ print $3 }')
		ping -c 2 $j &> /dev/null &&
    			printf "Connectivity with $j $hip.......................................Passed \n" ||
    			printf "Connectivity with $j.......................................Failed \n"	
	done
}

pipo_connectivity() {
	
	echo -e "\nTesting connection with Adapter\n"

	ip_addresses=$(cat components.txt | grep -i "adapter" | awk '{ print $2 }')	
	for i in $ip_addresses;
	do
		printf "Connectivity with $i on port 7426\n"
		nc -z -v $i 7426
	done
	
	hostname=$(cat components.txt | grep -i "adapter" | awk '{ print $3 }')
	for j in $hostname;
	do
		printf "Connectivity with $j on port 7426\n"
		nc -z -v $j 7426
	done

	echo -e "\nTesting connection with Core\n"
	cip=$(cat components.txt | grep -i "core" | awk '{ print $2 }')	
	chn=$(cat components.txt | grep -i "core" | awk '{ print $3 }')
	printf "Connectivity with $cip on port 1443\n"
		nc -z -v $cip 1443
	printf "Connectivity with $cip on port 8086\n"
		nc -z -v $cip 8086
	printf "Connectivity with $cip on port 8765\n"
		nc -z -v $cip 8765
	printf "Connectivity with $chn on port 1443\n"
		nc -z -v $chn 1443
	printf "Connectivity with $chn on port 8086\n"
		nc -z -v $chn 8086
	printf "Connectivity with $chn on port 8765\n"
		nc -z -v $chn 8765

}

# ram_check() function is for checking the ram provided to the component according to thier deployment environment
ram_check() {
	sysram=$(free -g | awk '/Mem:/ {print $2}')
	sysramg=$(free -h | awk '/Mem:/ {print $2}')
	if [[ "$ENVIR" == "1" ]]; then
		if [ "$COMPONENT" == "1" ]; then
			if [ $sysram -ge "16" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg"
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg. It should be atleast 16GB"
			fi
		fi
		if [ "$COMPONENT" == "2" ]; then
			if [ $sysram -ge "16" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg"
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg. It should be atleast 16GB"
			fi
		fi
		if [ "$COMPONENT" == "3" ]; then
			if [ $sysram -ge "48" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg"
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg. It should be atleast 48GB"
			fi
		fi
		if [ "$COMPONENT" == "4" ]; then
			if [ $sysram -ge "16" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg"
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg. It should be atleast 16GB"
			fi
		fi
		if [ "$COMPONENT" == "5" ]; then
			if [ $sysram -ge "16" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg"
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg. It should be atleast 16GB"
			fi
		fi
	elif [ "$ENVIR" == "2" ]; then
		if [ "$COMPONENT" == "1" ]; then
			if [ $sysram -ge "32" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg"
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg. It should be atleast 32GB"
			fi
		fi
		if [ "$COMPONENT" == "2" ]; then
			if [ $sysram -ge "32" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg"
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg. It should be atleast 32GB"
			fi
		fi
		if [ "$COMPONENT" == "3" ]; then
			if [ $sysram -ge "64" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg"
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg. It should be atleast 64GB"
			fi
		fi
		if [ "$COMPONENT" == "4" ]; then
			if [ $sysram -ge "32" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg"
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg. It should be atleast 32GB"
			fi
		fi
		if [ "$COMPONENT" == "5" ]; then
			if [ $sysram -ge "32" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg"
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment"
				echo "RAM provided: $sysramg. It should be atleast 32GB"
			fi
		fi
	fi
}

# cpu_check() function is for checking the vcpu provided to the component according to thier deployment environment
cpu_check() {
	syscpu=$(nproc)
	if [[ "$ENVIR" == "1" ]]; then
		if [ "$COMPONENT" == "1" ]; then
			if [ $syscpu -ge "8" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu"
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu. It should be atleast 8vCPU"
			fi
		fi
		if [ "$COMPONENT" == "2" ]; then
			if [ $syscpu -ge "8" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu"
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu. It should be atleast 8vCPU"
			fi
		fi
		if [ "$COMPONENT" == "3" ]; then
			if [ $syscpu -ge "24" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu"
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu. It should be atleast 24vCPU"
			fi
		fi
		if [ "$COMPONENT" == "4" ]; then
			if [ $syscpu -ge "8" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu"
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu. It should be atleast 8vCPU"
			fi
		fi
		if [ "$COMPONENT" == "5" ]; then
			if [ $syscpu -ge "8" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu"
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu. It should be atleast 8vCPU"
			fi
		fi
	elif [ "$ENVIR" == "2" ]; then
		if [ "$COMPONENT" == "1" ]; then
			if [ $syscpu -ge "16" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu"
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu. It should be atleast 16vCPU"
			fi
		fi
		if [ "$COMPONENT" == "2" ]; then
			if [ $syscpu -ge "16" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu"
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu. It should be atleast 16vCPU"
			fi
		fi
		if [ "$COMPONENT" == "3" ]; then
			if [ $syscpu -ge "32" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu"
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu. It should be atleast 32vCPU"
			fi
		fi
		if [ "$COMPONENT" == "4" ]; then
			if [ $syscpu -ge "16" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu"
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu. It should be atleast 16vCPU"
			fi
		fi
		if [ "$COMPONENT" == "5" ]; then
			if [ $syscpu -ge "16" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu"
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment"
				echo "vCPU provided: $syscpu. It should be atleast 16vCPU"
			fi
		fi
	fi
}


# store_check() function is for checking the "/DNIF" partition size provided to the component according to thier deployment environment
#it will also check if the root "/" partition of minimum 200GB is provided or not. 
store_check() {

	dsizeik=$(df -k /DNIF | awk '/dev/ {print $2}')
	rsizeik=$(df -k / | awk '/dev/ {print $2}')
	dnifsize=$(df -h /DNIF | awk '/dev/ {print $2}')
	rootsize=$(df -h / | awk '/dev/ {print $2}')
	HOS=$(lsblk -o ROTA,MOUNTPOINT | grep -i "DNIF" | awk '{ print $1 }')

	if [[ "$ENVIR" == "1" ]]; then
		if [ "$COMPONENT" == "1" ]; then
			if [ $dsizeik -ge "524288000" ]; then
				echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize"
			else
				echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize. It should be atleast 500GB"
			fi
		fi
		if [ "$COMPONENT" == "2" ]; then
			if [ $dsizeik -ge "335544320" ]; then
				echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize"
			else
				echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB"
			fi
		fi
		if [ "$COMPONENT" == "3" ]; then
			if [ $dsizeik -ge "524288000" ]; then
				echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize"
			else
				echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize. It should be atleast 500GB"
			fi
		fi
		if [ "$COMPONENT" == "4" ]; then
			if [ $dsizeik -ge "335544320" ]; then
				echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize"
			else
				echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB"
			fi
		fi
		if [ "$COMPONENT" == "5" ]; then
			if [ $dsizeik -ge "335544320" ]; then
				echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize"
			else
				echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB"
			fi
		fi
	elif [ "$ENVIR" == "2" ]; then
		if [ "$COMPONENT" == "1" ]; then
			if [  $dsizeik -ge "1048576000" ]; then
				echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize"
			else
				echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize. It should be atleast 1TB"
			fi
		fi
		if [ "$COMPONENT" == "2" ]; then
			if [  $dsizeik -ge "335544320" ]; then
				echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize"
			else
				echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB"
			fi
		fi
		if [ "$COMPONENT" == "3" ]; then
			if [  $dsizeik -ge "524288000" ]; then
				echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize"
			else
				echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize. It should be atleast 500GB"
			fi
		fi
		if [ "$COMPONENT" == "4" ]; then
			if [  $dsizeik -ge "335544320" ]; then
				echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize"
			else
				echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB"
			fi
		fi
		if [ "$COMPONENT" == "5" ]; then
			if [  $dsizeik -ge "335544320" ]; then
				echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize"
			else
				echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment"
				echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB"
			fi
		fi
	fi

	echo -e "----------------------------------------------------------------------------------\n"

	if [ $rsizeik -ge "209715200" ]; then
		echo "Root '/' Partition Check Passed the Minimum Configuration"
		echo "Root '/' Partition provided: $rootsize"
	else
		echo "Root '/' Partition Check Failed the Minimum Configuration"
		echo "Root '/' Partition provided: $rootsize. It should be atleast 200GB"
	fi

    echo -e "----------------------------------------------------------------------------------\n"

	echo -e "Checking /DNIF Storage Type (HDD/SSD):"
	if [[ $HOS == "1" ]]; then
		echo "The Provided ""/DNIF"" Partition is HDD"
	elif [[ $HOS == "0" ]]; then
		echo "The Provided ""/DNIF"" Partition is SSD "
	else
		echo "The ""/DNIF"" Partition is not provided "
	fi

}

#Port connectivity checks
port_connectivity() {

	echo -e "PORT Prerequisites:\n"
	PORT=(80 22)
	for port in "${PORT[@]}";
	do
		if timeout 15 bash -c "</dev/tcp/localhost/$port" &> /dev/null
		then
			printf "Port $port .....................................................Open\n"
		else
			printf "Port $port .....................................................Closed\n"
		fi
	done
}

#URL connectivity checks
url_connectiity() {
	echo -e "Connectivity Statistics:\n"
	for site in  https://github.com/ https://raw.github.com/ https://hub.docker.com/  https://hog.dnif.it/
	do
		if wget -O - -q -t 1 --timeout=6 --spider -S "$site" 2>&1 | grep -w "200\|301" ; then
	    	printf "Connectivity with $site.................................Passed \n"
		else
	    	printf "Connectivity with $site.................................Failed \n"
		fi
	done
}

#Checking selinux status
selinux_check() {

	echo -e "Checking SELinux status:\n" 
	if [ ! -f "/usr/sbin/sestatus" ]; then
		echo "policycoreutils is not installed"
	else
		sestatus
	fi
}

#Checking Proxy on the server
proxy_check() {
  
        echo -e "Checking Proxy:\n" 
        if [ -z "$(env | grep -i "proxy")" ]; then
                echo "No proxy found on the server"
        elif [[ ! -z "$(env | grep -i "proxy")" ]]; then
                echo -e "Proxy found on the server:\n"
                $(env | grep -i "proxy")
        fi
}

#-------------------------------------------------------CASE-------------------------------------------------------------

case "${COMPONENT^^}" in
	1)
		echo -e "----------------------------------------------------------------------------------"
		ip_connectivity "Core"
		ip_connectivity "Datanode"
		ip_connectivity "Adapter"
		ip_connectivity "Console"
		echo -e "----------------------------------------------------------------------------------\n"
		ram_check
		echo -e "----------------------------------------------------------------------------------\n"
		cpu_check
		echo -e "----------------------------------------------------------------------------------\n"
		store_check
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "Current Server Time:\n"
		timedatectl
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "Network interface configuration:\n"
		ifconfig
		echo -e "----------------------------------------------------------------------------------\n"
		port_connectivity
		echo -e "----------------------------------------------------------------------------------\n"
		url_connectiity
		echo -e "----------------------------------------------------------------------------------\n"
		selinux_check
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "umask:\n"
		umask
		echo -e "----------------------------------------------------------------------------------\n"
		proxy_check
		echo -e "----------------------------------------------------------------------------------"
		;;
	2)
		echo -e "----------------------------------------------------------------------------------"
		ip_connectivity "Core"
		ip_connectivity "Datanode"
		ip_connectivity "Adapter"
		ip_connectivity "Console"
		echo -e "----------------------------------------------------------------------------------\n"
		ram_check
		echo -e "----------------------------------------------------------------------------------\n"
		cpu_check
		echo -e "----------------------------------------------------------------------------------\n"
		store_check
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "Current Server Time:\n"
		timedatectl
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "Network interface configuration:\n"
		ifconfig
		echo -e "----------------------------------------------------------------------------------\n"
		port_connectivity
		echo -e "----------------------------------------------------------------------------------\n"
		url_connectiity
		echo -e "----------------------------------------------------------------------------------\n"
		selinux_check
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "umask:\n"
		umask
		echo -e "----------------------------------------------------------------------------------\n"
		proxy_check
		echo -e "----------------------------------------------------------------------------------"
		;;
	3)
		echo -e "----------------------------------------------------------------------------------"
		ip_connectivity "Core"
		ip_connectivity "Datanode"
		ip_connectivity "Adapter"
		ip_connectivity "Console"
		echo -e "----------------------------------------------------------------------------------\n"
		ram_check
		echo -e "----------------------------------------------------------------------------------\n"
		cpu_check
		echo -e "----------------------------------------------------------------------------------\n"
		store_check
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "Current Server Time:\n"
		timedatectl
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "Network interface configuration:\n"
		ifconfig
		echo -e "----------------------------------------------------------------------------------\n"
		port_connectivity
		echo -e "----------------------------------------------------------------------------------\n"
		url_connectiity
		echo -e "----------------------------------------------------------------------------------\n"
		selinux_check
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "umask:\n"
		umask
		echo -e "----------------------------------------------------------------------------------\n"
		proxy_check
		echo -e "----------------------------------------------------------------------------------"
		;;
	4)
		echo -e "----------------------------------------------------------------------------------"
		ip_connectivity "Core"
		ip_connectivity "Datanode"
		ip_connectivity "Adapter"
		ip_connectivity "Console"
		echo -e "----------------------------------------------------------------------------------\n"
		ram_check
		echo -e "----------------------------------------------------------------------------------\n"
		cpu_check
		echo -e "----------------------------------------------------------------------------------\n"
		store_check
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "Current Server Time:\n"
		timedatectl
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "Network interface configuration:\n"
		ifconfig
		echo -e "----------------------------------------------------------------------------------\n"
		port_connectivity
		echo -e "----------------------------------------------------------------------------------\n"
		url_connectiity
		echo -e "----------------------------------------------------------------------------------\n"
		selinux_check
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "umask:\n"
		umask
		echo -e "----------------------------------------------------------------------------------\n"
		proxy_check
		echo -e "----------------------------------------------------------------------------------"
		;;
	5)
		echo -e "----------------------------------------------------------------------------------"
		ip_connectivity "Pico"
		ip_connectivity "Adapter"
		echo -e "----------------------------------------------------------------------------------\n"
		ram_check
		echo -e "----------------------------------------------------------------------------------\n"
		cpu_check
		echo -e "----------------------------------------------------------------------------------\n"
		store_check
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "Current Server Time:\n"
		timedatectl
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "Network interface configuration:\n"
		ifconfig
		echo -e "----------------------------------------------------------------------------------\n"
		port_connectivity
		echo -e "----------------------------------------------------------------------------------\n"
		url_connectiity
		echo -e "----------------------------------------------------------------------------------\n"
		selinux_check
		echo -e "----------------------------------------------------------------------------------\n"
		echo -e "umask:\n"
		umask
		echo -e "----------------------------------------------------------------------------------\n"
		proxy_check
		echo -e "----------------------------------------------------------------------------------\n"
		pipo_connectivity
		echo -e "----------------------------------------------------------------------------------"
		;;
	esac
