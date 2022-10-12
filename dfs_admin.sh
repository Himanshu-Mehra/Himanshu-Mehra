#!/bin/bash
dateis=$(date +%d%m%Y)
timeis=$(date +%H%M%S)
uname=$(cat /DNIF/DL/csltuconfig/username)
export HADOOP_USER_NAME=$uname
cd /opt/hadoop-3.2.3/bin/
./hdfs dfsadmin -report >> /var/tmp/dfsadmin_$dateis"T"$timeis.out