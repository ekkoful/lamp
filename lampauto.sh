#! /bin/bash
#
# This is a script for auto install LAMP
#
# Apache + MySql + Php and PhpMyAdmin and so on 
#
# SystemVersion: Centos6 
#
# SoftwareVersion: Apache2.4.29 MySql5.5.32 Php5.5.38
#
# Author: beechoing@126.com
#
# Github: https://github.com/beechoing/lampauto.git
#

echo "自动安装脚本已经执行,请稍等^_^"
echo "部分安装记录存入文件~/.lampistall.log"
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
clear

echo 'export PATH=$PATH:/usr/local/httpd24/bin:/usr/local/mysql/bin:/usr/local/php/bin' > /etc/profile.d/lamp.sh
source /etc/profile.d/lamp.sh
clear

cd 

touch ~/.lampinstall.log 
log=~/.lampinstall.log

## 安装前需要环境
## echo "安装前需要的环境:" >> $log
## yum install wget -y >> $log

## 创建目录保存编译的源码包
echo "正在下载需要的源码包......"
echo "由于MySQL是二进制包,下载可能会有点慢，请耐心等待"
mkdir /sourcelamp 					
wget http://www-eu.apache.org/dist//httpd/httpd-2.4.29.tar.gz -qP /sourcelamp 
wget http://mirrors.hust.edu.cn/apache//apr/apr-1.6.3.tar.gz -qP/sourcelamp
wget http://mirrors.hust.edu.cn/apache//apr/apr-util-1.6.1.tar.gz -qP /sourcelamp
wget http://cn2.php.net/get/php-5.5.38.tar.gz/from/this/mirror -qO /sourcelamp/php-5.5.38.tar.gz
wget http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.32-linux2.6-x86_64.tar.gz -qP /sourcelamp


echo "安装开发环境:" >> $log
yum -y groupinstall "Development tools" >> $log
yum -y groupinstall "Server Platform Development" >> $log
yum -y install bzip2-devel libmcrypt-devel libxml2-devel >> $log	## 编译PHP需要
yum -y install expat-devel >> $log									## 编译apr-util
yum -y install pcre-devel >> $log									## 编译Apache
yum -y install libaio >> $log										## 安装Mysql需要

mkdir /sourcemake
echo "正在编译安装Apache^_^......"

echo "编译安装apr..."
cd 
tar xf /sourcelamp/apr-1.6.3.tar.gz -C /sourcemake/
cd /sourcemake/apr-1.6.3
./configure --prefix=/usr/local/apr
make && make install 

echo "编译安装apr-util..."
cd 
tar xf /sourcelamp/apr-util-1.6.1.tar.gz -C /sourcemake/
cd /sourcemake/apr-util-1.6.1 
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
make && make install  

echo "编译安装Apache2.4..."
cd
tar xf /sourcelamp/httpd-2.4.29.tar.gz -C /sourcemake/
cd /sourcemake/httpd-2.4.29
./configure --prefix=/usr/local/httpd24 --sysconfdir=/etc/httpd24 --enable-so \
	--enable-ssl --enable-cgi --enable-rewrite --with-zlib --with-pcre \
	--with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util \
	--enable-modules=most --enable-mpms-shared=all --with-mpm=prefork 
make && make install 


echo "正在二进制安装MySql^_^......"

echo "新建目录/mydata/data作为mysql数据的存放目录" >> $log
cd 
mkdir -pv /mysqldb/data >> $log

echo "建立mysql用户组" >> $log
groupadd -r mysql
useradd -g mysql -r -s /sbin/nologin -M -d /mysqldb/data mysql
chown -R mysql:mysql /mysqldb/data

tar xf /sourcelamp/mysql-5.5.32-linux2.6-x86_64.tar.gz -C /usr/local
cd /usr/local/
#rm /usr/local/mysql >> $log
ln -sv mysql-5.5.32-linux2.6-x86_64 mysql
cd mysql
chown -R mysql:mysql .
scripts/mysql_install_db --user=mysql --datadir=/mysqldb/data
chown -R root .

echo "为mysql提供配置文件" >> $log
cp support-files/my-large.cnf /etc/my.cnf
#echo "datadir = /mysqldb/data" >> /etc/my.cnf

echo "为mysql提供sysv服务脚本" >> $log
cd /usr/local/mysql
cp support-files/mysql.server /etc/rc.d/init.d/mysqld
chmod +x /etc/rc.d/init.d/mysqld

## 添加至服务列表
chkconfig --add mysqld
## chkconfig mysqld on

## 添加man文档
echo "MANPATH /usr/local/mysql/man" >> /etc/man.config

ln -sv /usr/local/mysql/include /usr/include/mysql
echo "/usr/local/mysql/lib" > /etc/ld.so.conf.d/mysql.conf
ldconfig

echo "正在编译安装php^_^......"
cd 
tar xf /sourcelamp/php-5.5.38.tar.gz -C /sourcemake
cd /sourcemake/php-5.5.38
./configure --prefix=/usr/local/php --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config \
	--enable-mbstring --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr \
	--enable-xml --enable-xml --enable-sockets --with-apxs2=/usr/local/httpd24/bin/apxs --with-mcrypt \
	--with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --with-bz2 --enable-maintainer-zts
make 
make install 

echo "为php提供配置文件" >> $log
cp php.ini-production /etc/php.ini


