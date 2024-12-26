#!/bin/bash
set -e

function jdk_upgrade () {
        # Get current OpenJDK version
        source /etc/profile
        current_version=$(java --version | grep -oP 'openjdk \K[0-9]+(\.[0-9]+\.[0-9]+)?')
        echo -e "\n[-] Current OpenJDK version found $current_version\n"
        if [[ "$current_version" == "20.0.2" ]]; then
                echo -e "[-] OpenJDK already installed with required version 20.0.2\n"
        else
                echo -e "[-] Starting OpenJDK update...!\n"
                # Checking OS to backup OLD OpenJDK 14
                if [[ "$os" == "centos" || "$os" == "rhel" ]]; then
                        mv /usr/lib/jvm/java-14-openjdk-amd64 /usr/lib/jvm/bkp_java-14-openjdk-amd64
                        mv /usr/lib/jdk-14 /usr/lib/bkp_jdk-14
                elif [ "$os" = "ubuntu" ]; then
                        mv /usr/lib/jvm/java-14-openjdk-amd64 /usr/lib/jvm/bkp_java-14-openjdk-amd64
                        mv /usr/lib/jvm/jdk-14 /usr/lib/jvm/bkp_jdk-14
                fi
                # Define the JDK download URL and target file
                jdk_url="https://download.java.net/java/GA/jdk20.0.2/6e380f22cbe7469fa75fb448bd903d8e/9/GPL/openjdk-20.0.2_linux-x64_bin.tar.gz"
                jdk_tarball="/var/tmp/openjdk-20.0.2_linux-x64_bin.tar.gz"
                # Check if the tarball already exists
                if [[ -f "$jdk_tarball" ]]; then
                        echo -e "[-] JDK tarball already exists at $jdk_tarball. Skipping download.\n"
                else
                        echo -e "[-] Downloading OpenJDK tarball...\n"
                        wget "$jdk_url" -O "$jdk_tarball"
                        if [[ $? -ne 0 ]]; then
                                echo -e "[-] Download failed. Exiting.\n"
                                exit 1
                        fi
                fi
                echo -e "[-] Installing OpenJDK 20.0.2\n"
                tar -xvf /var/tmp/openjdk-20.0.2_linux-x64_bin.tar.gz -C /usr/lib/jvm/ >> /DNIF/upgrade.log
                # Set environment variables for OpenJDK 20.0.2
                echo "export JAVA_HOME=/usr/lib/jvm/jdk-20.0.2" > /etc/profile.d/jdk.sh
                echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile.d/jdk.sh
                mkdir -p /usr/lib/jvm/java-20.0.2-openjdk-amd64
                cp -r /usr/lib/jvm/jdk-20.0.2/* /usr/lib/jvm/java-20.0.2-openjdk-amd64/
                echo "export JAVA_HOME=/usr/lib/jvm/java-20.0.2-openjdk-amd64" >> /etc/profile
                # Reload the profile scripts to apply changes
                source /etc/profile.d/jdk.sh
                source /etc/profile
                # Check the installed version
                latest_version=$(java --version | grep -oP 'openjdk \K[0-9]+(\.[0-9]+\.[0-9]+)?')
                # Validate the installation
                if [[ "$latest_version" == "20.0.2" ]]; then
                        echo -e "[-] OpenJDK version successfully upgraded from $current_version to $latest_version.\n"
                else
                        echo -e "[-] There was an issue installing OpenJDK. Current version: $latest_version.\n"
                fi
        fi
}

# Get current OS
if [ -r /etc/os-release ]; then
        os="$(. /etc/os-release && echo "$ID")"
fi
# DNIF Version Tag
tag='v9.4.1'

case "${os}" in
        ubuntu|centos)
                container_list=( "pico-v9" "adapter-v9" "datanode-v9" "console-v9" "core-v9" )
                for container_name in "${container_list[@]}"
                do
                        if [ -e /DNIF/docker-compose.yaml ]; then
                                dc_container_name=$(cat /DNIF/docker-compose.yaml | grep "$container_name" | awk '{print $2}')
                                if [ "$dc_container_name" == "$container_name" ]; then
                                        dcfound=$dc_container_name
                                        dcversion=$(cat /DNIF/docker-compose.yaml | grep 'image' | grep 'core' | awk '{print $2}' | cut -d':' -f2)
                                        dcversion2=$(cat /DNIF/docker-compose.yaml | grep 'image' | grep 'datanode' | awk '{print $2}' | cut -d':' -f2)
                                fi
                        fi
                        if [ -e /DNIF/LC/docker-compose.yaml ]; then
                                dc_container_name=$(cat /DNIF/LC/docker-compose.yaml | grep "$container_name" | awk '{print $2}')
                                if [ "$dc_container_name" == "$container_name" ]; then
                                        dcfound=$dc_container_name
                                        dcversion=$(cat /DNIF/LC/docker-compose.yaml | grep 'image' | grep 'console' | awk '{print $2}' | cut -d':' -f2)
                                fi
                        fi
                        if [ -e /DNIF/DL/docker-compose.yaml ]; then
                                if [ ! -e /DNIF/docker-compose.yaml ]; then
                                        dc_container_name=$(cat /DNIF/DL/docker-compose.yaml | grep "$container_name" | awk '{print $2}')
                                        if [ "$dc_container_name" == "$container_name" ]; then
                                                dcfound=$dc_container_name
                                                dcversion=$(cat /DNIF/DL/docker-compose.yaml | grep 'image' | grep 'datanode' | awk '{print $2}' | cut -d':' -f2)
                                        fi
                                fi
                        fi
                        if [ -e /DNIF/AD/docker-compose.yaml ]; then
                                dc_container_name=$(cat /DNIF/AD/docker-compose.yaml | grep "$container_name" | awk '{print $2}')
                                if [ "$dc_container_name" == "$container_name" ]; then
                                        dcfound=$dc_container_name
                                        dcversion=$(cat /DNIF/AD/docker-compose.yaml | grep 'image' | grep 'adapter' | awk '{print $2}' | cut -d':' -f2)
                                fi
                        fi
                        if [ -e /DNIF/PICO/docker-compose.yaml ]; then
                                dc_container_name=$(cat /DNIF/PICO/docker-compose.yaml | grep "$container_name" | awk '{print $2}')
                                if [ "$dc_container_name" == "$container_name" ]; then
                                        dcfound=$dc_container_name
                                        dcversion=$(cat /DNIF/PICO/docker-compose.yaml | grep 'image' | grep 'pico' | awk '{print $2}' | cut -d':' -f2)
                                fi
                        fi
                        if [ "$dcfound" == "$container_name" ]; then
                                echo -e "\n[-] Checking for current running container and version from docker-compose\n"
                                echo -e "[-] Found $dcfound with current version $dcversion\n"
                                
                                int_tag=$(echo ${tag#v} | tr -d '.')
                                int_dcversion=$(echo ${dcversion#v} | tr -d '.')
                                if [[ "$int_dcversion" =~ ^[0-9]{4}$ ]]; then
                                        # Remove the last digit
                                        int_dcversion=${int_dcversion:0:-1}
                                fi

                                if (( $int_tag == $int_dcversion )); then
                                        echo -e  "[-] Version Up-to-date\n"
                                elif (( $int_tag < $int_dcversion )); then
                                        echo -e "[-] Version Downgrade not allowed!\n"
                                        echo -e "[-] The curent version - $dcversion is greater than the upgrading tag version - $tag\n"
                                elif (( $int_tag > $int_dcversion )); then
                                        echo -e "[-] The curent version - $dcversion is lower than the upgrading tag version - $tag\n"
                                        echo -e "[-] Starting Version upgrade!\n"
                                        if [ "$container_name" == "core-v9" ]; then
                                                #Updating OpenJDK version
                                                jdk_upgrade
                                                echo -e "[-] Updating docker-compose..\n"
                                                file="/DNIF/docker-compose.yaml"
                                                # Adding UI_IP in docker-compose file
                                                ui_exist=$(echo "$(cat /DNIF/docker-compose.yaml | grep 'UI_IP')")
                                                if [ -n "$ui_exist" ]; then
                                                        echo -e "[-] UI_IP already exist in docker-compose file"
                                                        echo -e "$ui_exist"
                                                else
                                                        UI_IP=""
                                                        while [[ ! $UI_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
                                                                echo -e "ENTER CONSOLE IP: \c"
                                                                read -r UI_IP
                                                        done
                                                        sed -i "/CORE_IP/a\      - 'UI_IP=$UI_IP'" $file
                                                fi
                                                # Updating DNIF version tag in docker-compose file
                                                if [ -e /DNIF/DL/docker-compose.yaml ]; then
                                                        file2="/DNIF/DL/docker-compose.yaml"
                                                        dcversion2=$(cat /DNIF/DL/docker-compose.yaml | grep 'image' | grep 'datanode' | awk '{print $2}' | cut -d':' -f2)
                                                        sed -i s/"$dcversion2"/"$tag"/g $file2
                                                fi
                                                sed -i s/"$dcversion"/"$tag"/g $file
                                                sed -i s/"$dcversion2"/"$tag"/g $file 
                                                echo -e "\n[-] Starting docker container\n"
                                                cd /DNIF
                                                docker-compose up -d
                                                if [ -e /DNIF/DL/docker-compose.yaml ]; then
                                                        cd /DNIF/DL
                                                        docker-compose up -d
                                                fi
                                                docker ps -a
                                        elif [ "$container_name" == "console-v9" ]; then
                                                echo -e "[-] Updating docker-compose..\n"
                                                file="/DNIF/LC/docker-compose.yaml"
                                                # Adding UI_IP in docker-compose file
                                                ui_exist=$(echo "$(cat /DNIF/LC/docker-compose.yaml | grep 'UI_IP')")
                                                if [ -n "$ui_exist" ]; then
                                                        echo -e "[-] UI_IP already exist in docker-compose file"
                                                        echo -e "$ui_exist"
                                                else
                                                        UI_IP=""
                                                        while [[ ! $UI_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
                                                                echo -e "ENTER CONSOLE IP: \c"
                                                                read -r UI_IP
                                                        done
                                                        sed -i "/restart/a\    environment:" $file
                                                        sed -i "/environment:/a\      - 'UI_IP=$UI_IP'" $file
                                                fi
                                                # Updating DNIF version tag in docker-compose file
                                                sed -i s/"$dcversion"/"$tag"/g $file
                                                echo -e "\n[-] Starting docker container\n"
                                                cd /DNIF/LC
                                                docker-compose up -d
                                                docker ps -a
                                        elif [ "$container_name" == "datanode-v9" ]; then
                                                #Updating OpenJDK version
                                                jdk_upgrade
                                                echo -e "[-] Updating docker-compose..\n"
                                                file="/DNIF/DL/docker-compose.yaml"
                                                sed -i s/"$dcversion"/"$tag"/g $file
                                                echo -e "\n[-] Starting docker container\n"
                                                cd /DNIF/DL
                                                docker-compose up -d
                                                docker ps -a
                                        elif [ "$container_name" == "adapter-v9" ]; then
                                                echo -e "[-] Updating docker-compose..\n"
                                                file="/DNIF/AD/docker-compose.yaml"
                                                # Adding HOST_IP in docker-compose file
                                                hi_exist=$(echo "$(cat /DNIF/AD/docker-compose.yaml | grep 'HOST_IP')")
                                                if [ -n "$hi_exist" ]; then
                                                        echo -e "[-] HOST_IP already exist in docker-compose file"
                                                        echo -e "$hi_exist"
                                                else
                                                        HOST_IP=""
                                                        while [[ ! $HOST_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
                                                                echo -e "ENTER ADAPTER IP: \c"
                                                                read -r HOST_IP
                                                        done
                                                        sed -i "/CORE_IP/a\      - 'HOST_IP=$HOST_IP'" $file
                                                fi
                                                sed -i s/"$dcversion"/"$tag"/g $file
                                                echo -e "\n[-] Starting docker container\n"
                                                cd /DNIF/AD
                                                docker-compose up -d
                                                docker ps -a
                                        elif [ "$container_name" == "pico-v9" ]; then
                                                echo -e "[-] Updating docker-compose..\n"
                                                file="/DNIF/PICO/docker-compose.yaml"
                                                sed -i s/"$dcversion"/"$tag"/g $file
                                                echo -e "\n[-] Starting docker container\n"
                                                cd /DNIF/PICO
                                                docker-compose up -d
                                                docker ps -a
                                        fi
                                fi
                        fi
                done
                echo -e "\n[-] Upgrade completed...!\n"
                ;;
        rhel)
                container_list=( "pico-v9" "adapter-v9" "datanode-v9" "console-v9" "core-v9" )
                for container_name in "${container_list[@]}"
                do
                        if [ -e /DNIF/podman-compose.yaml ]; then
                                dc_container_name=$(cat /DNIF/podman-compose.yaml | grep "$container_name" | awk '{print $2}')
                                if [ "$dc_container_name" == "$container_name" ]; then
                                        dcfound=$dc_container_name
                                        dcversion=$(cat /DNIF/podman-compose.yaml | grep 'image' | grep 'core' | awk '{print $2}' | cut -d':' -f2)
                                        if [ -e /DNIF/DL/podman-compose.yaml ]; then
                                                dcversion2=$(cat /DNIF/DL/podman-compose.yaml | grep 'image' | grep 'datanode' | awk '{print $2}' | cut -d':' -f2)
                                        fi
                                fi
                        fi
                        if [ -e /DNIF/LC/podman-compose.yaml ]; then
                                dc_container_name=$(cat /DNIF/LC/podman-compose.yaml | grep "$container_name" | awk '{print $2}')
                                if [ "$dc_container_name" == "$container_name" ]; then
                                        dcfound=$dc_container_name
                                        dcversion=$(cat /DNIF/LC/podman-compose.yaml | grep 'image' | grep 'console' | awk '{print $2}' | cut -d':' -f2)
                                fi
                        fi
                        if [ -e /DNIF/DL/podman-compose.yaml ]; then
                                if [ ! -e /DNIF/podman-compose.yaml ]; then
                                        dc_container_name=$(cat /DNIF/DL/podman-compose.yaml | grep "$container_name" | awk '{print $2}')
                                        if [ "$dc_container_name" == "$container_name" ]; then
                                                dcfound=$dc_container_name
                                                dcversion=$(cat /DNIF/DL/podman-compose.yaml | grep 'image' | grep 'datanode' | awk '{print $2}' | cut -d':' -f2)
                                        fi
                                fi
                        fi
                        if [ -e /DNIF/AD/podman-compose.yaml ]; then
                                dc_container_name=$(cat /DNIF/AD/podman-compose.yaml | grep "$container_name" | awk '{print $2}')
                                if [ "$dc_container_name" == "$container_name" ]; then
                                        dcfound=$dc_container_name
                                        dcversion=$(cat /DNIF/AD/podman-compose.yaml | grep 'image' | grep 'adapter' | awk '{print $2}' | cut -d':' -f2)
                                fi
                        fi
                        if [ -e /DNIF/PICO/podman-compose.yaml ]; then
                                dc_container_name=$(cat /DNIF/PICO/podman-compose.yaml | grep "$container_name" | awk '{print $2}')
                                if [ "$dc_container_name" == "$container_name" ]; then
                                        dcfound=$dc_container_name
                                        dcversion=$(cat /DNIF/PICO/podman-compose.yaml | grep 'image' | grep 'pico' | awk '{print $2}' | cut -d':' -f2)
                                fi
                        fi
                        if [ "$dcfound" == "$container_name" ]; then
                                echo -e "\n[-] Checking for current running container and version from podman-compose\n"
                                echo -e "[-] Found $dcfound with current version $dcversion\n"
                                
                                int_tag=$(echo ${tag#v} | tr -d '.')
                                int_dcversion=$(echo ${dcversion#v} | tr -d '.')
                                if [[ "$int_dcversion" =~ ^[0-9]{4}$ ]]; then
                                        # Remove the last digit
                                        int_dcversion=${int_dcversion:0:-1}
                                fi

                                if (( $int_tag == $int_dcversion )); then
                                        echo -e  "[-] Version Up-to-date\n"
                                elif (( $int_tag < $int_dcversion )); then
                                        echo -e "[-] Version Downgrade not allowed!\n"
                                        echo -e "[-] The curent version - $dcversion is greater than the upgrading tag version - $tag\n"
                                elif (( $int_tag > $int_dcversion )); then
                                        echo -e "[-] The curent version - $dcversion is lower than the upgrading tag version - $tag\n"
                                        echo -e "[-] Starting Version upgrade!\n"
                                        if [ "$container_name" == "core-v9" ]; then
                                                #Updating OpenJDK version
                                                jdk_upgrade
                                                echo -e "[-] Updating podman-compose..\n"
                                                file1="/DNIF/podman-compose.yaml"
                                                file2="/DNIF/DL/podman-compose.yaml"
                                                # Adding UI_IP in podman-compose file
                                                ui_exist=$(echo "$(cat /DNIF/podman-compose.yaml | grep 'UI_IP')")
                                                if [ -n "$ui_exist" ]; then
                                                        echo -e "[-] UI_IP already exist in podman-compose file"
                                                        echo -e "$ui_exist"
                                                else
                                                        UI_IP=""
                                                        while [[ ! $UI_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
                                                                echo -e "ENTER CONSOLE IP: \c"
                                                                read -r UI_IP
                                                        done
                                                        sed -i "/CORE_IP/a\      - 'UI_IP=$UI_IP'" $file1
                                                fi
                                                # Updating DNIF version tag in podman-compose file
                                                sed -i s/"$dcversion"/"$tag"/g $file1
                                                sed -i s/"$dcversion2"/"$tag"/g $file2
                                                echo -e "\n[-] Starting podman container\n"
                                                cd /DNIF
                                                podman-compose up -d
                                                cd /DNIF/DL
                                                podman-compose up -d
                                                podman ps -a
                                        elif [ "$container_name" == "console-v9" ]; then
                                                echo -e "[-] Updating podman-compose..\n"
                                                file="/DNIF/LC/podman-compose.yaml"
                                                # Adding UI_IP in podman-compose file
                                                ui_exist=$(echo "$(cat /DNIF/LC/podman-compose.yaml | grep 'UI_IP')")
                                                if [ -n "$ui_exist" ]; then
                                                        echo -e "[-] UI_IP already exist in podman-compose file"
                                                        echo -e "$ui_exist"
                                                else
                                                        UI_IP=""
                                                        while [[ ! $UI_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
                                                                echo -e "ENTER CONSOLE IP: \c"
                                                                read -r UI_IP
                                                        done
                                                        sed -i "/restart/a\    environment:" $file
                                                        sed -i "/environment:/a\      - 'UI_IP=$UI_IP'" $file
                                                fi
                                                # Updating DNIF version tag in podman-compose file
                                                sed -i s/"$dcversion"/"$tag"/g $file
                                                echo -e "\n[-] Starting podman container\n"
                                                cd /DNIF/LC
                                                podman-compose up -d
                                                podman ps -a
                                        elif [ "$container_name" == "datanode-v9" ]; then
                                                #Updating OpenJDK version
                                                jdk_upgrade
                                                echo -e "[-] Updating podman-compose..\n"
                                                file="/DNIF/DL/podman-compose.yaml"
                                                sed -i s/"$dcversion"/"$tag"/g $file
                                                echo -e "\n[-] Starting podman container\n"
                                                cd /DNIF/DL
                                                podman-compose up -d
                                                podman ps -a
                                        elif [ "$container_name" == "adapter-v9" ]; then
                                                echo -e "[-] Updating podman-compose..\n"
                                                file="/DNIF/AD/podman-compose.yaml"
                                                # Adding HOST_IP in podman-compose file
                                                hi_exist=$(echo "$(cat /DNIF/AD/podman-compose.yaml | grep 'HOST_IP')")
                                                if [ -n "$hi_exist" ]; then
                                                        echo -e "[-] HOST_IP already exist in podman-compose file"
                                                        echo -e "$hi_exist"
                                                else
                                                        HOST_IP=""
                                                        while [[ ! $HOST_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; do
                                                                echo -e "ENTER ADAPTER IP: \c"
                                                                read -r HOST_IP
                                                        done
                                                        sed -i "/CORE_IP/a\      - 'HOST_IP=$HOST_IP'" $file
                                                fi
                                                sed -i s/"$dcversion"/"$tag"/g $file
                                                echo -e "\n[-] Starting podman container\n"
                                                cd /DNIF/AD
                                                podman-compose up -d
                                                podman ps -a
                                        elif [ "$container_name" == "pico-v9" ]; then
                                                echo -e "[-] Updating podman-compose..\n"
                                                file="/DNIF/PICO/podman-compose.yaml"
                                                sed -i s/"$dcversion"/"$tag"/g $file
                                                echo -e "\n[-] Starting podman container\n"
                                                cd /DNIF/PICO
                                                podman-compose up -d
                                                podman ps -a
                                        fi
                                fi
                        fi
                done
                echo -e "\n[-] Upgrade completed...!\n"
                ;;
        esac
