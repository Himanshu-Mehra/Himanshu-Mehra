#!/bin/bash

if [ -r /etc/os-release ]; then
  os="$(. /etc/os-release && echo -e "$ID")"
fi

function co_down() {

  echo -e "Cleaning CORE Server\n"

  if [[ $os == "ubuntu" ]]; then

      if [[ $(docker ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then
          echo -e "Stopping the Console container\n"
          cd /DNIF/LC/
          docker-compose down
      fi

      if [[ $(docker ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
          if [[ -e /DNIF/DL/docker-compose.yaml ]]; then
              echo -e "Stopping the Master-Datanode container\n"
              cd /DNIF/DL
              docker-compose down
          fi
      fi

      if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
          echo -e "Stopping the CORE & Master-Datanode container\n"
          cd /DNIF/
          docker-compose down
      fi

  fi

  if [[ $os == "rhel" ]]; then

      if [[ $(podman ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then
          echo -e "Stopping the Console container\n"
          cd /DNIF/LC/
          podman-compose down
      fi

      if [[ $(podman ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
          if [[ -e /DNIF/DL/podman-compose.yaml ]]; then
              echo -e "Stopping the Master-Datanode container\n"
              cd /DNIF/DL
              podman-compose down
          fi
      fi

      if [[ $(podman ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
          echo -e "Stopping the CORE & Master-Datanode container\n"
          cd /DNIF/
          podman-compose down
      fi

  fi

}

function core_cleaning() {

  if [[ -e /DNIF/CO/ ]]; then
      cd /DNIF/
      rm -rf CO/
      echo -e "Removed /DNIF/CO/\n"
  fi

  if [[ -e /DNIF/DL/ ]]; then
      cd /DNIF/
      rm -rf DL/
      echo -e "Removed /DNIF/DL/\n"
  fi

  if [[ -e /DNIF/LC/ ]]; then
      cd /DNIF/
      rm -rf LC/
      echo -e "Removed /DNIF/LC/\n"
  fi

  if [[ -e /DNIF/backup/ ]]; then
      cd /DNIF/
      rm -rf backup/
      echo -e "Removed /DNIF/backup/\n"
  fi

  if [[ -e /DNIF/docker-compose.yaml ]]; then
      cd /DNIF/
      rm -rf docker-compose.yaml
      echo -e "Removed /DNIF/docker-compose.yaml\n"
  fi

  if [[ -e /DNIF/podman-compose.yaml ]]; then
      cd /DNIF/
      rm -rf podman-compose.yaml
      echo -e "Removed /DNIF/podman-compose.yaml\n"
  fi

  if [[ -e /DNIF/install.log ]]; then
      cd /DNIF/
      rm -rf install.log
      echo -e "Removed /DNIF/install.log\n"
  fi

  hadoop=$(ls /opt/ | grep -i "hadoop-3")
  for i in $hadoop;
  do
          if [[ -e /opt/$i ]]; then
                  rm -rf /opt/$i
                  echo -e "Removed /opt/$i\n"
          fi
  done

  spark=$(ls /opt/ | grep -i "spark-3")
  for j in $spark;
  do
          if [[ -e /opt/$j ]]; then
                  rm -rf /opt/$j
                  echo -e "Removed /opt/$j\n"
          fi
  done

  if [[ -e /opt/gohdfs/ ]]; then
      cd /opt/
      rm -rf gohdfs/
      echo -e "Removed /opt/gohdfs/\n"
  fi

  if [[ -e /opt/containerd/ ]]; then
      cd /opt/
      rm -rf containerd/
      echo -e "Removed /opt/containerd/\n"
  fi

  if [[ -e /etc/systemd/system/hadoop-namenode.service ]]; then
      echo -e "Stopping hadoop-namenode.service\n"
      cd /etc/systemd/system/
      systemctl stop hadoop-namenode.service
      rm -rf hadoop-namenode.service
      echo -e "Removed /etc/systemd/system/hadoop-namenode.service\n"
  fi

  if [[ -e /etc/systemd/system/hadoop-datanode.service ]]; then
      echo -e "Stopping hadoop-datanode.service\n"
      cd /etc/systemd/system/
      systemctl stop hadoop-datanode.service
      rm -rf hadoop-datanode.service
      echo -e "Removed /etc/systemd/system/hadoop-datanode.service\n"
  fi

  if [[ -e /etc/systemd/system/spark-master.service ]]; then
      echo -e "Stopping spark-master.service\n"
      cd /etc/systemd/system/
      systemctl stop spark-master.service
      rm -rf spark-master.service
      echo -e "Removed /etc/systemd/system/spark-master.service\n"
  fi

  if [[ -e /etc/systemd/system/spark-slave.service ]]; then
      echo -e "Stopping spark-slave.service\n"
      cd /etc/systemd/system/
      systemctl stop spark-slave.service
      rm -rf spark-slave.service
      echo -e "Removed /etc/systemd/system/spark-slave.service\n"
  fi

  if [[ -e /etc/systemd/system/thrift-server.service ]]; then
      echo -e "Stopping thrift-server.service\n"
      cd /etc/systemd/system/
      systemctl stop thrift-server.service
      rm -rf thrift-server.service
      echo -e "Removed /etc/systemd/system/thrift-server.service\n"
  fi


  systemctl daemon-reload
  systemctl reset-failed
  
  echo -e "-----------------------------------------------------------------------------------------\n"
  echo -e "docker ps -a"
  docker ps -a
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /DNIF/"
  ls /DNIF/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /opt/"
  ls /opt/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /etc/systemd/system/"
  ls /etc/systemd/system/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "Cleaning Completed...!!!\n"

}

function dn_clean() {


  echo -e "Cleaning DATANODE\n"

  if [[ $(docker ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
      echo -e "Stopping the DATANODE container\n"
      cd /DNIF/DL/
      docker-compose down
  fi

  if [[ -e /DNIF/DL/ ]]; then
      cd /DNIF/
      rm -rf DL/
      echo -e "Removed /DNIF/DL/\n"
  fi

  if [[ -e /DNIF/backup/ ]]; then
      cd /DNIF/
      rm -rf backup/
      echo -e "Removed /DNIF/backup/\n"
  fi

  if [[ -e /DNIF/install.log ]]; then
      cd /DNIF/
      rm -rf install.log
      echo -e "Removed /DNIF/install.log/\n"
  fi

  hadoop=$(ls /opt/ | grep -i "hadoop-3")
  for i in $hadoop;
  do
          if [[ -e /opt/$i ]]; then
                  rm -rf /opt/$i
                  echo -e "Removed /opt/$i\n"
          fi
  done

  spark=$(ls /opt/ | grep -i "spark-3")
  for j in $spark;
  do
          if [[ -e /opt/$j ]]; then
                  rm -rf /opt/$j
                  echo -e "Removed /opt/$j\n"
          fi
  done

  if [[ -e /opt/gohdfs/ ]]; then
      cd /opt/
      rm -rf gohdfs/
      echo -e "Removed /opt/gohdfs/\n"
  fi

  if [[ -e /opt/containerd/ ]]; then
      cd /opt/
      rm -rf containerd/
      echo -e "Removed /opt/containerd/\n"
  fi

  if [[ -e /etc/systemd/system/hadoop-namenode.service ]]; then
      echo -e "Stopping hadoop-namenode.service\n"
      cd /etc/systemd/system/
      systemctl stop hadoop-namenode.service
      rm -rf hadoop-namenode.service
      echo -e "Removed /etc/systemd/system/hadoop-namenode.service\n"
  fi

  if [[ -e /etc/systemd/system/hadoop-datanode.service ]]; then
      echo -e "Stopping hadoop-datanode.service\n"
      cd /etc/systemd/system/
      systemctl stop hadoop-datanode.service
      rm -rf hadoop-datanode.service
      echo -e "Removed /etc/systemd/system/hadoop-datanode.service\n"
  fi

  if [[ -e /etc/systemd/system/spark-master.service ]]; then
      echo -e "Stopping spark-master.service\n"
      cd /etc/systemd/system/
      systemctl stop spark-master.service
      rm -rf spark-master.service
      echo -e "Removed /etc/systemd/system/spark-master.service\n"
  fi

  if [[ -e /etc/systemd/system/spark-slave.service ]]; then
      echo -e "Stopping spark-slave.service\n"
      cd /etc/systemd/system/
      systemctl stop spark-slave.service
      rm -rf spark-slave.service
      echo -e "Removed /etc/systemd/system/spark-slave.service\n"
  fi

  if [[ -e /etc/systemd/system/thrift-server.service ]]; then
      echo -e "Stopping thrift-server.service\n"
      cd /etc/systemd/system/
      systemctl stop thrift-server.service
      rm -rf thrift-server.service
      echo -e "Removed /etc/systemd/system/thrift-server.service\n"
  fi


  systemctl daemon-reload
  systemctl reset-failed
  
  echo -e "-----------------------------------------------------------------------------------------\n"
  echo -e "docker ps -a"
  docker ps -a
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /DNIF/"
  ls /DNIF/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /opt/"
  ls /opt/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /etc/systemd/system/"
  ls /etc/systemd/system/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "Cleaning Completed...!!!\n"

}

function lc_clean() {

  echo -e "Cleaning CONSOLE\n"

  if [[ $os == "ubuntu" ]]; then
    if [[ $(docker ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then
        echo -e "Stopping the CONSOLE container\n"
        cd /DNIF/LC/
        docker-compose down
    fi
  fi

  if [[ $os == "rhel" ]]; then
    if [[ $(podman ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then
        echo -e "Stopping the CONSOLE container\n"
        cd /DNIF/LC/
        podman-compose down
    fi
  fi



  if [[ -e /DNIF/LC/ ]]; then
      cd /DNIF/
      rm -rf LC/
      echo -e "Removed /DNIF/LC/\n"
  fi
 
  if [[ -e /DNIF/backup/ ]]; then
      cd /DNIF/
      rm -rf backup/
      echo -e "Removed /DNIF/backup/\n"
  fi

  if [[ -e /DNIF/install.log ]]; then
      cd /DNIF/
      rm -rf install.log
      echo -e "Removed /DNIF/install.log/\n"
  fi

  systemctl daemon-reload
  systemctl reset-failed
  
  echo -e "-----------------------------------------------------------------------------------------\n"
  echo -e "docker ps -a"
  docker ps -a
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /DNIF/"
  ls /DNIF/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /opt/"
  ls /opt/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /etc/systemd/system/"
  ls /etc/systemd/system/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "Cleaning Completed...!!!\n"

}

function ad_clean() {
  
  echo -e "Cleaning ADAPTER\n"

  if [[ $os == "ubuntu" ]]; then
    if [[ $(docker ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then
        echo -e "Stopping the Adapter container\n"
        cd /DNIF/AD/
        docker-compose down
    fi
  fi

  if [[ $os == "rhel" ]]; then
    if [[ $(podman ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then
        echo -e "Stopping the Adapter container\n"
        cd /DNIF/AD/
        podman-compose down
    fi
  fi

  if [[ -e /DNIF/AD/ ]]; then
      cd /DNIF/
      rm -rf AD/
      echo -e "Removed /DNIF/AD/\n"
  fi
 
  if [[ -e /DNIF/backup/ ]]; then
      cd /DNIF/
      rm -rf backup/
      echo -e "Removed /DNIF/backup/\n"
  fi

  if [[ -e /DNIF/install.log ]]; then
      cd /DNIF/
      rm -rf install.log
      echo -e "Removed /DNIF/install.log/\n"
  fi

  systemctl daemon-reload
  systemctl reset-failed
  
  echo -e "-----------------------------------------------------------------------------------------\n"
  echo -e "docker ps -a"
  docker ps -a
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /DNIF/"
  ls /DNIF/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /opt/"
  ls /opt/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /etc/systemd/system/"
  ls /etc/systemd/system/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "Cleaning Completed...!!!\n"

}

function pc_clean() {
  
  echo -e "Cleaning PICO\n"

  if [[ $os == "ubuntu" ]]; then
    if [[ $(docker ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then
        echo -e "Stopping the Pico container\n"
        cd /DNIF/PICO/
        docker-compose down
    fi
  fi

  if [[ $os == "rhel" ]]; then
    if [[ $(podman ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then
        echo -e "Stopping the Pico container\n"
        cd /DNIF/PICO/
        podman-compose down
    fi
  fi

  if [[ -e /DNIF/PICO/ ]]; then
      cd /DNIF/
      rm -rf PICO/
      echo -e "Removed /DNIF/PC/\n"
  fi
 
  if [[ -e /DNIF/backup/ ]]; then
      cd /DNIF/
      rm -rf backup/
      echo -e "Removed /DNIF/backup/\n"
  fi

  if [[ -e /DNIF/install.log ]]; then
      cd /DNIF/
      rm -rf install.log
      echo -e "Removed /DNIF/install.log/\n"
  fi

  systemctl daemon-reload
  systemctl reset-failed
  
  echo -e "-----------------------------------------------------------------------------------------\n"
  echo -e "docker ps -a"
  docker ps -a
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /DNIF/"
  ls /DNIF/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /opt/"
  ls /opt/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "ls /etc/systemd/system/"
  ls /etc/systemd/system/
  echo -e "\n-----------------------------------------------------------------------------------------\n"
  echo -e "Cleaning Completed...!!!\n"

}

echo -e "* Select a DNIF component you want to clean"
echo -e "    [1] Core (CO)"
echo -e "    [2] Console (LC)"
echo -e "    [3] Datanode (DN)"
echo -e "    [4] Adapter (AD)"
echo -e "    [5] Pico (PC)\n"

COMP=""
while [[ ! $COMP =~ ^[1-5] ]]; do
  echo -e "Pick the number corresponding to the component (1 - 5):  \c"
  read -r COMP
  done
echo -e "-----------------------------------------------------------------------------------------\n"

case "${COMP^^}" in
    1)
        co_down
        core_cleaning
        ;;
    2)
        lc_clean
        ;;
    3)
        dn_clean
        ;;
    4)
        ad_clean
        ;;
    5)
        pc_clean
        ;;
    esac
        

