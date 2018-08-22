#! /bin/bash
# 
# script for conf the apache and php
#
# SystemVersion: CentOS6
#
# Author: beechoing@126.com
#
# GitHub: https://github.com/beechoing
#
#

clear
source /etc/profile.d/lamp.sh

if [ -f /etc/my.cnf ];then
	mv /etc/my.cnf{,.bak}
fi 

if [ -f /etc/httpd24/httpd.conf ];then
	mv /etc/httpd24/httpd.conf{,.bak}
fi 

if [ -f /etc/rc.d/init.d/httpd24 ];then
	rm /etc/rc.d/init.d/httpd24{,.bak} 
fi

if [ -d /var/httpd24 ];then
	rm /var/httpd24 -rf 
fi 

mkdir /var/httpd24
url=`pwd`
cp $url/conf/httpd.conf /etc/httpd24/httpd.conf
cp $url/conf/my.cnf /etc/my.cnf
cp $url/conf/httpd24 /etc/rc.d/init.d/httpd24
cp $url/conf/index.php /var/httpd24/index.php


cd 
chmod +x /etc/rc.d/init.d/httpd24
chkconfig --add httpd24


service mysqld restart
service httpd24 restart

mysqladmin -u root password "123456" 

curl 127.0.0.1 --silent > test.txt
cat test.txt | grep Success
if [ $? == 0 ];then
	echo "LAMP环境配置完成"
else
	echo "对不起,LAMP环境配置失败"
fi
