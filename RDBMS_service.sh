#!/bin/bash

cwd=$(pwd)
pypath=$(which python3)
fina=${1%.*}
cd /etc/systemd/system/


echo -e "[Unit]
Description=RDBMS Log Shipper

[Service]
User=root
WorkingDirectory=$cwd
ExecStart=$pypath RDBMS-Log-Shipper/rdbms_connector.py RDBMS-Log-Shipper/config/$1
Restart=always

[Install]
WantedBy=multi-user.target">>rdbms_logshipper_$fina.service

systemctl daemon-reload

systemctl enable rdbms_logshipper_$fina.service

systemctl is-enabled rdbms_logshipper_$fina.service

systemctl start rdbms_logshipper_$fina.service

systemctl status rdbms_logshipper_$fina.service

#write out current crontab
crontab -l > mycronservice
#echo new cron into cron file
echo "*/30 * * * * systemctl restart rdbms_logshipper_$fina.service" >> mycronservice
#install new cron file
crontab mycronservice
rm mycronservice
