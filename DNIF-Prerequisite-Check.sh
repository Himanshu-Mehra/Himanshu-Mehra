#!/bin/bash


#-------------------------------------------------Reading inputs-------------------------------------------------------

echo -e "* Select the DNIF component you would like to check Prerequisites for:" | tee -a ./prechecks.log
echo -e "    [1] Core (CO)" | tee -a ./prechecks.log
echo -e "    [2] Local Console (LC)" | tee -a ./prechecks.log
echo -e "    [3] Datanode (DN)" | tee -a ./prechecks.log
echo -e "    [4] Adapter (AD)" | tee -a ./prechecks.log
echo -e "    [5] Pico\n" | tee -a ./prechecks.log

COMPONENT=""
while [[ ! $COMPONENT =~ ^[1-5] ]]; do
	echo -e "Pick the number corresponding to the component (1 - 5):  \c" | tee -a ./prechecks.log
        read -r COMPONENT
done

echo -e $COMPONENT >> ./prechecks.log

echo -e "\n* Select the Deployment Environment:" | tee -a ./prechecks.log
echo -e "    [1] Test Environment" | tee -a ./prechecks.log
echo -e "    [2] Production Environment\n" | tee -a ./prechecks.log

ENVIR=""
while [[ ! $ENVIR =~ ^[1-2] ]]; do
	echo -e "Pick the number corresponding to the Environemt (1 - 2):  \c" | tee -a ./prechecks.log
    read -r ENVIR
done

echo -e $ENVIR >> ./prechecks.log

echo -e "\n-----------------------------------Enter Customer Name----------------------------" | tee -a ./prechecks.log
echo -e "Enter the Customer Name :  \c" | tee -a ./prechecks.log
read -r cust_name

echo -e $cust_name >> ./prechecks.log

#----------------------------------------------------Functions----------------------------------------------------------


# ip_connectivity() function is for testing the connectivty using ping command
ip_connectivity() {
	
	echo -e "\nTesting connection with ${1}:\n" | tee -a ./prechecks.log

	ip_addresses=$(cat components.txt | grep -i ${1} | awk '{ print $2 }')	
	for i in $ip_addresses;
	do
		ping -c 2 $i &> /dev/null &&
    			printf "Connectivity with $i.......................................Passed \n" | tee -a ./prechecks.log ||
    			printf "Connectivity with $i.......................................Failed \n" | tee -a ./prechecks.log
	done
	
	hostname=$(cat components.txt | grep -i ${1} | awk '{ print $3 }')
	for j in $hostname;
	do
		hip=$(ping -c 1 $j | grep -i "bytes of data" | awk '{ print $3 }')
		ping -c 2 $j &> /dev/null &&
    			printf "Connectivity with $j $hip.......................................Passed \n" | tee -a ./prechecks.log ||
    			printf "Connectivity with $j.......................................Failed \n" | tee -a ./prechecks.log
	done
}

pipo_connectivity() {
	
	echo -e "\nTesting connection with Adapter\n" | tee -a ./prechecks.log

	ip_addresses=$(cat components.txt | grep -i "adapter" | awk '{ print $2 }')	
	for i in $ip_addresses;
	do
		printf "Connectivity with $i on port 7426\n" | tee -a ./prechecks.log
		nc -z -v $i 7426
		nc -z -v $i 7426 &>> prechecks.log
	done
	
	hostname=$(cat components.txt | grep -i "adapter" | awk '{ print $3 }')
	for j in $hostname;
	do
		printf "Connectivity with $j on port 7426\n" | tee -a ./prechecks.log
		nc -z -v $j 7426 
		nc -z -v $j 7426 &>> prechecks.log
	done

	echo -e "\nTesting connection with Core\n" | tee -a ./prechecks.log
	cip=$(cat components.txt | grep -i "core" | awk '{ print $2 }')	
	chn=$(cat components.txt | grep -i "core" | awk '{ print $3 }')
	printf "Connectivity with $cip on port 1443\n" | tee -a ./prechecks.log
		nc -z -v $cip 1443 
		nc -z -v $cip 1443 &>> prechecks.log
	printf "Connectivity with $cip on port 8086\n" | tee -a ./prechecks.log
		nc -z -v $cip 8086 
		nc -z -v $cip 8086 &>> prechecks.log
	printf "Connectivity with $cip on port 8765\n" | tee -a ./prechecks.log
		nc -z -v $cip 8765 
		nc -z -v $cip 8765 &>> prechecks.log
	printf "Connectivity with $chn on port 1443\n" | tee -a ./prechecks.log
		nc -z -v $chn 1443 
		nc -z -v $chn 1443 &>> prechecks.log
	printf "Connectivity with $chn on port 8086\n" | tee -a ./prechecks.log
		nc -z -v $chn 8086 
		nc -z -v $chn 8086 &>> prechecks.log
	printf "Connectivity with $chn on port 8765\n" | tee -a ./prechecks.log
		nc -z -v $chn 8765 
		nc -z -v $chn 8765 &>> prechecks.log

}

# ram_check() function is for checking the ram provided to the component according to thier deployment environment
ram_check() {
	sysram=$(free -g | awk '/Mem:/ {print $2}')
	sysramg=$(free -h | awk '/Mem:/ {print $2}')
	echo -e "Checking RAM provided to the server:\n" | tee -a ./prechecks.log
	if [[ "$ENVIR" == "1" ]]; then
		if [ "$COMPONENT" == "1" ]; then
			if [ $sysram -ge "16" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg" | tee -a ./prechecks.log
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg. It should be atleast 16GB" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "2" ]; then
			if [ $sysram -ge "16" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg" | tee -a ./prechecks.log
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg. It should be atleast 16GB" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "3" ]; then
			if [ $sysram -ge "48" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg" | tee -a ./prechecks.log
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg. It should be atleast 48GB" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "4" ]; then
			if [ $sysram -ge "16" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg" | tee -a ./prechecks.log
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg. It should be atleast 16GB" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "5" ]; then
			if [ $sysram -ge "16" ]; then
				echo "RAM Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg" | tee -a ./prechecks.log
			else
				echo "RAM Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg. It should be atleast 16GB" | tee -a ./prechecks.log
			fi
		fi
	elif [ "$ENVIR" == "2" ]; then
		if [ "$COMPONENT" == "1" ]; then
			if [ $sysram -ge "32" ]; then
				echo "RAM Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg" | tee -a ./prechecks.log
			else
				echo "RAM Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg. It should be atleast 32GB" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "2" ]; then
			if [ $sysram -ge "32" ]; then
				echo "RAM Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg" | tee -a ./prechecks.log
			else
				echo "RAM Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg. It should be atleast 32GB"  | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "3" ]; then
			if [ $sysram -ge "64" ]; then
				echo "RAM Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg" | tee -a ./prechecks.log
			else
				echo "RAM Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg. It should be atleast 64GB" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "4" ]; then
			if [ $sysram -ge "32" ]; then
				echo "RAM Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg" | tee -a ./prechecks.log
			else
				echo "RAM Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg. It should be atleast 32GB" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "5" ]; then
			if [ $sysram -ge "32" ]; then
				echo "RAM Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg" | tee -a ./prechecks.log
			else
				echo "RAM Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "RAM provided: $sysramg. It should be atleast 32GB" | tee -a ./prechecks.log
			fi
		fi
	fi
}

# cpu_check() function is for checking the vcpu provided to the component according to thier deployment environment
cpu_check() {
	syscpu=$(nproc)
	echo -e "Checking vCPU provided to the server:\n" | tee -a ./prechecks.log
	if [[ "$ENVIR" == "1" ]]; then
		if [ "$COMPONENT" == "1" ]; then
			if [ $syscpu -ge "8" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu" | tee -a ./prechecks.log
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu. It should be atleast 8vCPU" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "2" ]; then
			if [ $syscpu -ge "8" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu" | tee -a ./prechecks.log
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu. It should be atleast 8vCPU" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "3" ]; then
			if [ $syscpu -ge "24" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu" | tee -a ./prechecks.log
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu. It should be atleast 24vCPU" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "4" ]; then
			if [ $syscpu -ge "8" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu" | tee -a ./prechecks.log
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu. It should be atleast 8vCPU" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "5" ]; then
			if [ $syscpu -ge "8" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu" | tee -a ./prechecks.log
			else
				echo "vCPU Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu. It should be atleast 8vCPU" | tee -a ./prechecks.log
			fi
		fi
	elif [ "$ENVIR" == "2" ]; then
		if [ "$COMPONENT" == "1" ]; then
			if [ $syscpu -ge "16" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu" | tee -a ./prechecks.log
			else
				echo "vCPU Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu. It should be atleast 16vCPU" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "2" ]; then
			if [ $syscpu -ge "16" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu" | tee -a ./prechecks.log
			else
				echo "vCPU Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu. It should be atleast 16vCPU" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "3" ]; then
			if [ $syscpu -ge "32" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu" | tee -a ./prechecks.log
			else
				echo "vCPU Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu. It should be atleast 32vCPU" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "4" ]; then
			if [ $syscpu -ge "16" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu" | tee -a ./prechecks.log
			else
				echo "vCPU Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu. It should be atleast 16vCPU" | tee -a ./prechecks.log
			fi
		fi
		if [ "$COMPONENT" == "5" ]; then
			if [ $syscpu -ge "16" ]; then
				echo "vCPU Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu" | tee -a ./prechecks.log
			else
				echo "vCPU Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
				echo "vCPU provided: $syscpu. It should be atleast 16vCPU" | tee -a ./prechecks.log
			fi
		fi
	fi
}


# store_check() function is for checking the "/DNIF" partition size provided to the component according to thier deployment environment
#it will also check if the root "/" partition of minimum 200GB is provided or not. 
store_check() {

	rsizeik=$(df -k / | awk '/dev/ {print $2}')
	rootsize=$(df -h / | awk '/dev/ {print $2}')
	HOS=$(lsblk -o ROTA,MOUNTPOINT | grep -i "DNIF" | awk '{ print $1 }')
	echo -e "Checking ""/DNIF"" partition size provided to the server:\n" | tee -a ./prechecks.log
	if [[ ! -z "$(df -h | grep "/DNIF")" ]]; then
		dsizeik=$(df -k /DNIF | awk '/dev/ {print $2}')
		dnifsize=$(df -h /DNIF | awk '/dev/ {print $2}')
		if [[ "$ENVIR" == "1" ]]; then
			if [ "$COMPONENT" == "1" ]; then
				if [ $dsizeik -ge "524288000" ]; then
					echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize" | tee -a ./prechecks.log
				else
					echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize. It should be atleast 500GB" | tee -a ./prechecks.log
				fi
			fi
			if [ "$COMPONENT" == "2" ]; then
				if [ $dsizeik -ge "335544320" ]; then
					echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize" | tee -a ./prechecks.log
				else
					echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB" | tee -a ./prechecks.log
				fi
			fi
			if [ "$COMPONENT" == "3" ]; then
				if [ $dsizeik -ge "524288000" ]; then
					echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize" | tee -a ./prechecks.log
				else
					echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize. It should be atleast 500GB" | tee -a ./prechecks.log
				fi
			fi
			if [ "$COMPONENT" == "4" ]; then
				if [ $dsizeik -ge "335544320" ]; then
					echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize" | tee -a ./prechecks.log
				else
					echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB" | tee -a ./prechecks.log
				fi
			fi
			if [ "$COMPONENT" == "5" ]; then
				if [ $dsizeik -ge "335544320" ]; then
					echo "/DNIF Partition Check Passed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize" | tee -a ./prechecks.log
				else
					echo "/DNIF Partition Check Failed the Minimum Configuration for Test Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB" | tee -a ./prechecks.log
				fi
			fi
		elif [ "$ENVIR" == "2" ]; then
			if [ "$COMPONENT" == "1" ]; then
				if [  $dsizeik -ge "1048576000" ]; then
					echo "/DNIF Partition Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize" | tee -a ./prechecks.log
				else
					echo "/DNIF Partition Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize. It should be atleast 1TB" | tee -a ./prechecks.log
				fi
			fi
			if [ "$COMPONENT" == "2" ]; then
				if [  $dsizeik -ge "335544320" ]; then
					echo "/DNIF Partition Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize" | tee -a ./prechecks.log
				else
					echo "/DNIF Partition Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB" | tee -a ./prechecks.log
				fi
			fi
			if [ "$COMPONENT" == "3" ]; then
				if [  $dsizeik -ge "524288000" ]; then
					echo "/DNIF Partition Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize" | tee -a ./prechecks.log
				else
					echo "/DNIF Partition Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize. It should be atleast 500GB" | tee -a ./prechecks.log
				fi
			fi
			if [ "$COMPONENT" == "4" ]; then
				if [  $dsizeik -ge "335544320" ]; then
					echo "/DNIF Partition Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize" | tee -a ./prechecks.log
				else
					echo "/DNIF Partition Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB" | tee -a ./prechecks.log
				fi
			fi
			if [ "$COMPONENT" == "5" ]; then
				if [  $dsizeik -ge "335544320" ]; then
					echo "/DNIF Partition Check Passed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize" | tee -a ./prechecks.log
				else
					echo "/DNIF Partition Check Failed the Minimum Configuration for Production Environment" | tee -a ./prechecks.log
					echo "/DNIF Partition provided: $dnifsize. It should be atleast 320GB" | tee -a ./prechecks.log
				fi
			fi
		fi
	else
		echo -e "The ""/DNIF"" Partition is not provided " | tee -a ./prechecks.log
	fi

	echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log

	echo -e "Checking ROOT partition size provided to the server:\n" | tee -a ./prechecks.log
	if [ $rsizeik -ge "209715200" ]; then
		echo "Root '/' Partition Check Passed the Minimum Configuration" | tee -a ./prechecks.log
		echo "Root '/' Partition provided: $rootsize" | tee -a ./prechecks.log
	else
		echo "Root '/' Partition Check Failed the Minimum Configuration" | tee -a ./prechecks.log
		echo "Root '/' Partition provided: $rootsize. It should be atleast 200GB" | tee -a ./prechecks.log
	fi

    echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log

	echo -e "Checking /DNIF Storage Type (HDD/SSD):\n" | tee -a ./prechecks.log
	if [[ $HOS == "1" ]]; then
		echo "The Provided ""/DNIF"" Partition is HDD" | tee -a ./prechecks.log
	elif [[ $HOS == "0" ]]; then
		echo "The Provided ""/DNIF"" Partition is SSD " | tee -a ./prechecks.log
	else
		echo "The ""/DNIF"" Partition is not provided " | tee -a ./prechecks.log
	fi

}

#Port connectivity checks
port_connectivity() {

	echo -e "PORT Prerequisites:\n" | tee -a ./prechecks.log
	PORT=(80 22)
	for port in "${PORT[@]}";
	do
		if timeout 15 bash -c "</dev/tcp/localhost/$port" &> /dev/null
		then
			printf "Port $port .....................................................Open\n" | tee -a ./prechecks.log
		else
			printf "Port $port .....................................................Closed\n" | tee -a ./prechecks.log
		fi
	done
}

#URL connectivity checks
url_connectiity() {
	echo -e "Connectivity Statistics:\n" | tee -a ./prechecks.log
	for site in  https://github.com/ https://raw.github.com/ https://hub.docker.com/  https://hog.dnif.it/
	do
		if wget -O - -q -t 1 --timeout=6 --spider -S "$site" 2>&1 | grep -w "200\|301" ; then
	    	printf "Connectivity with $site.................................Passed \n" | tee -a ./prechecks.log
		else
	    	printf "Connectivity with $site.................................Failed \n" | tee -a ./prechecks.log
		fi
	done
}

#Checking selinux status
selinux_check() {

	echo -e "Checking SELinux status:\n"  | tee -a ./prechecks.log
	if [ ! -f "/usr/sbin/sestatus" ]; then
		echo "policycoreutils is not installed" | tee -a ./prechecks.log
	else
		sestatus | tee -a ./prechecks.log
	fi
}

#Checking Proxy on the server
proxy_check() {
  
        echo -e "Checking Proxy:\n" | tee -a ./prechecks.log
        if [ -z "$(env | grep -i "proxy")" ]; then
                echo "No proxy found on the server" | tee -a ./prechecks.log
        elif [[ ! -z "$(env | grep -i "proxy")" ]]; then
                echo -e "Proxy found on the server:\n" | tee -a ./prechecks.log
                $(env | grep -i "proxy") | tee -a ./prechecks.log
        fi
}

#-------------------------------------------------------CASE-------------------------------------------------------------

case "${COMPONENT^^}" in
	1)
		echo -e "----------------------------------------------------------------------------------" | tee -a ./prechecks.log
		ip_connectivity "Core"
		ip_connectivity "Datanode"
		ip_connectivity "Adapter"
		ip_connectivity "Console"
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		ram_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		cpu_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		store_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "Current Server Time:\n" | tee -a ./prechecks.log
		timedatectl | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "Network interface configuration:\n" | tee -a ./prechecks.log
		ifconfig | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		port_connectivity
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		url_connectiity
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		selinux_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "umask:\n" | tee -a ./prechecks.log
		umask | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		proxy_check
		echo -e "----------------------------------------------------------------------------------" | tee -a ./prechecks.log
		;;
	2)
		echo -e "----------------------------------------------------------------------------------" | tee -a ./prechecks.log
		ip_connectivity "Core"
		ip_connectivity "Datanode"
		ip_connectivity "Adapter"
		ip_connectivity "Console"
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		ram_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		cpu_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		store_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "Current Server Time:\n" | tee -a ./prechecks.log
		timedatectl | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "Network interface configuration:\n" | tee -a ./prechecks.log
		ifconfig | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		port_connectivity
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		url_connectiity
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		selinux_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "umask:\n" | tee -a ./prechecks.log
		umask | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		proxy_check
		echo -e "----------------------------------------------------------------------------------" | tee -a ./prechecks.log
		;;
	3)
		echo -e "----------------------------------------------------------------------------------" | tee -a ./prechecks.log
		ip_connectivity "Core"
		ip_connectivity "Datanode"
		ip_connectivity "Adapter"
		ip_connectivity "Console"
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		ram_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		cpu_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		store_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "Current Server Time:\n" | tee -a ./prechecks.log
		timedatectl | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "Network interface configuration:\n" | tee -a ./prechecks.log
		ifconfig | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		port_connectivity
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		url_connectiity
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		selinux_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "umask:\n" | tee -a ./prechecks.log
		umask | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		proxy_check
		echo -e "----------------------------------------------------------------------------------" | tee -a ./prechecks.log
		;;
	4)
		echo -e "----------------------------------------------------------------------------------" | tee -a ./prechecks.log
		ip_connectivity "Core"
		ip_connectivity "Datanode"
		ip_connectivity "Adapter"
		ip_connectivity "Console"
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		ram_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		cpu_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		store_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "Current Server Time:\n" | tee -a ./prechecks.log
		timedatectl | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "Network interface configuration:\n" | tee -a ./prechecks.log
		ifconfig | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		port_connectivity
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		url_connectiity
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		selinux_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "umask:\n" | tee -a ./prechecks.log
		umask | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		proxy_check
		echo -e "----------------------------------------------------------------------------------" | tee -a ./prechecks.log
		;;
	5)
		echo -e "----------------------------------------------------------------------------------" | tee -a ./prechecks.log
		ip_connectivity "Pico"
		ip_connectivity "Adapter"
		ip_connectivity "Core"
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		ram_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		cpu_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		store_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "Current Server Time:\n" | tee -a ./prechecks.log
		timedatectl | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "Network interface configuration:\n" | tee -a ./prechecks.log
		ifconfig | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		port_connectivity
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		url_connectiity
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		selinux_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		echo -e "umask:\n" | tee -a ./prechecks.log
		umask | tee -a ./prechecks.log
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		proxy_check
		echo -e "----------------------------------------------------------------------------------\n" | tee -a ./prechecks.log
		pipo_connectivity
		echo -e "----------------------------------------------------------------------------------" | tee -a ./prechecks.log
		;;
	esac