#!/bin/bash

function co_clean() {


  echo "Cleaning CORE"
  if [[ $(docker ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then
      echo "Stopping the CONSOLE conatiner"
      cd /DNIF/LC/
      docker-compose down
  fi

  if [[ $(docker ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
      if [[ -e /DNIF/DL/docker-compose.yaml ]]; then
          cd /DNIF/DL
          docker-compose down
      fi
  fi

  if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
      echo "Stopping the CORE conatiner"
      cd /DNIF/
      docker-compose down
  fi

  if [[ -e /DNIF/CO/ ]]; then
      cd /DNIF/
      rm -rf CO/
  fi

  if [[ -e /DNIF/DL/ ]]; then
      cd /DNIF/
      rm -rf DL/
  fi

  if [[ -e /DNIF/LC/ ]]; then
      cd /DNIF/
      rm -rf LC/
  fi

  if [[ -e /DNIF/backup/ ]]; then
      cd /DNIF/
      rm -rf backup/
  fi

  if [[ -e /DNIF/docker-compose.yaml ]]; then
      cd /DNIF/
      rm -rf docker-compose.yaml
  fi

  if [[ -e /DNIF/install.log ]]; then
      cd /DNIF/
      rm -rf install.log
  fi

  rm -rf /opt/hadoop*

  rm -rf /opt/spark*

  if [[ -e /opt/gohdfs/ ]]; then
      cd /opt/
      rm -rf gohdfs/
  fi

  if [[ -e /opt/containerd/ ]]; then
      cd /opt/
      rm -rf containerd/
  fi

  if [[ -e /etc/systemd/system/hadoop-namenode.service ]]; then
      cd /etc/systemd/system/
      systemctl stop hadoop-namenode.service
      rm -rf hadoop-namenode.service
  fi

  if [[ -e /etc/systemd/system/hadoop-datanode.service ]]; then
      cd /etc/systemd/system/
      systemctl stop hadoop-datanode.service
      rm -rf hadoop-datanode.service
  fi

  if [[ -e /etc/systemd/system/spark-master.service ]]; then
      cd /etc/systemd/system/
      systemctl stop spark-master.service
      rm -rf spark-master.service
  fi

  if [[ -e /etc/systemd/system/spark-slave.service ]]; then
      cd /etc/systemd/system/
      systemctl stop spark-slave.service
      rm -rf spark-slave.service
  fi

  if [[ -e /etc/systemd/system/thrift-server.service ]]; then
      cd /etc/systemd/system/
      systemctl stop thrift-server.service
      rm -rf thrift-server.service
  fi


  systemctl daemon-reload
  systemctl reset-failed
  
  echo "-----------------------------------------------------------------------------------------"
  echo "docker ps -a"
  docker ps -a
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /DNIF/"
  ls /DNIF/
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /opt/"
  ls /opt/
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /etc/systemd/system/"
  ls /etc/systemd/system/
  echo "-----------------------------------------------------------------------------------------"
  echo "Cleaning Completed"

}

function dn_clean() {


  echo "Cleaning DATANODE"
  if [[ $(docker ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
      echo "Stopping the DATANODE conatiner"
      cd /DNIF/DL/
      docker-compose down
  fi

  if [[ -e /DNIF/DL/ ]]; then
      cd /DNIF/
      rm -rf DL/
  fi

  if [[ -e /DNIF/backup/ ]]; then
      cd /DNIF/
      rm -rf backup/
  fi

  if [[ -e /DNIF/install.log ]]; then
      cd /DNIF/
      rm -rf install.log
  fi

  rm -rf /opt/hadoop*

  rm -rf /opt/spark*

  if [[ -e /opt/gohdfs/ ]]; then
      cd /opt/
      rm -rf gohdfs/
  fi

  if [[ -e /opt/containerd/ ]]; then
      cd /opt/
      rm -rf containerd/
  fi

  if [[ -e /etc/systemd/system/hadoop-namenode.service ]]; then
      cd /etc/systemd/system/
      systemctl stop hadoop-namenode.service
      rm -rf hadoop-namenode.service
  fi

  if [[ -e /etc/systemd/system/hadoop-datanode.service ]]; then
      cd /etc/systemd/system/
      systemctl stop hadoop-datanode.service
      rm -rf hadoop-datanode.service
  fi

  if [[ -e /etc/systemd/system/spark-master.service ]]; then
      cd /etc/systemd/system/
      systemctl stop spark-master.service
      rm -rf spark-master.service
  fi

  if [[ -e /etc/systemd/system/spark-slave.service ]]; then
      cd /etc/systemd/system/
      systemctl stop spark-slave.service
      rm -rf spark-slave.service
  fi

  if [[ -e /etc/systemd/system/thrift-server.service ]]; then
      cd /etc/systemd/system/
      systemctl stop thrift-server.service
      rm -rf thrift-server.service
  fi


  systemctl daemon-reload
  systemctl reset-failed
  
  echo "-----------------------------------------------------------------------------------------"
  echo "docker ps -a"
  docker ps -a
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /DNIF/"
  ls /DNIF/
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /opt/"
  ls /opt/
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /etc/systemd/system/"
  ls /etc/systemd/system/
  echo "-----------------------------------------------------------------------------------------"
  echo "Cleaning Completed"

}

function lc_clean() {

  echo "Cleaning CONSOLE"
  if [[ $(docker ps -a --format '{{.Names}}' | grep -w console-v9) == "console-v9" ]]; then
      echo "Stopping the CONSOLE conatiner"
      cd /DNIF/LC/
      docker-compose down
  fi

  if [[ -e /DNIF/LC/ ]]; then
      cd /DNIF/
      rm -rf LC/
  fi
 
  if [[ -e /DNIF/backup/ ]]; then
      cd /DNIF/
      rm -rf backup/
  fi

  if [[ -e /DNIF/install.log ]]; then
      cd /DNIF/
      rm -rf install.log
  fi

  systemctl daemon-reload
  systemctl reset-failed
  
  echo "-----------------------------------------------------------------------------------------"
  echo "docker ps -a"
  docker ps -a
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /DNIF/"
  ls /DNIF/
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /opt/"
  ls /opt/
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /etc/systemd/system/"
  ls /etc/systemd/system/
  echo "-----------------------------------------------------------------------------------------"
  echo "Cleaning Completed"

}

function ad_clean() {
  
  echo "Cleaning ADAPTER"
  if [[ $(docker ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then
      echo "Stopping the Adapter conatiner"
      cd /DNIF/AD/
      docker-compose down
  fi

  if [[ -e /DNIF/AD/ ]]; then
      cd /DNIF/
      rm -rf AD/
  fi
 
  if [[ -e /DNIF/backup/ ]]; then
      cd /DNIF/
      rm -rf backup/
  fi

  if [[ -e /DNIF/install.log ]]; then
      cd /DNIF/
      rm -rf install.log
  fi

  systemctl daemon-reload
  systemctl reset-failed
  
  echo "-----------------------------------------------------------------------------------------"
  echo "docker ps -a"
  docker ps -a
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /DNIF/"
  ls /DNIF/
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /opt/"
  ls /opt/
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /etc/systemd/system/"
  ls /etc/systemd/system/
  echo "-----------------------------------------------------------------------------------------"
  echo "Cleaning Completed"

}

function pc_clean() {
  
  echo "Cleaning PICO"
  if [[ $(docker ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then
      echo "Stopping the Pico conatiner"
      cd /DNIF/PICO/
      docker-compose down
  fi

  if [[ -e /DNIF/PICO/ ]]; then
      cd /DNIF/
      rm -rf PICO/
  fi
 
  if [[ -e /DNIF/backup/ ]]; then
      cd /DNIF/
      rm -rf backup/
  fi

  if [[ -e /DNIF/install.log ]]; then
      cd /DNIF/
      rm -rf install.log
  fi

  systemctl daemon-reload
  systemctl reset-failed
  
  echo "-----------------------------------------------------------------------------------------"
  echo "docker ps -a"
  docker ps -a
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /DNIF/"
  ls /DNIF/
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /opt/"
  ls /opt/
  echo "-----------------------------------------------------------------------------------------"
  echo "ls /etc/systemd/system/"
  ls /etc/systemd/system/
  echo "-----------------------------------------------------------------------------------------"
  echo "Cleaning Completed"

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
echo -e "-----------------------------------------------------------------------------------------"
case "${COMP^^}" in
    1)
        co_clean
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
        

