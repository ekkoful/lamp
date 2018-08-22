#! /bin/bash
# 
# script for test the system
#
# SystemVersion: CentOS6
#
# Author: beechoing@126.com
#
# Github: https://github.com/beechoing
#
#
echo "安装LAMP前的测试和清理脚本..."
echo "测试系统位数和系统版本"
release=`cat /etc/redhat-release | cut -d" " -f3 | cut -d"." -f1`
sys=`cat /etc/redhat-release`
bit=`getconf LONG_BIT`
if [ $release ==  6 ];then 
	echo "系统版本正确,系统为$sys"
	echo ""
	if [ $bit == 64 ];then
		echo "系统位数正确,为64位"
		echo "测试httpd服务器是否已经安装"
		httpd -v &> /dev/null
		if [ $? == 0  ];then 
			echo "httpd服务器已经存在!!并准备关闭服务..."
			read -n 1 -p "请问是否关闭服务(y|n):" answer
			if [ $answer == y ];then 
				echo ""
				service httpd stop
				chkconfig httpd off
			elif [ $answer == n ];then 
				echo ""
				echo "服务没有关闭,安装LAMP或许会有不可预知的错误!!"
			else 
				echo ""
				echo "请输入正确指令"
			fi
		else
			echo "httpd服务器没有安装!!"
		fi 

		echo "测试MySQL服务器是否已经安装"
		mysql --version &> /dev/null 
		if [ $? == 0 ];then
			echo "mysql服务器已经安装!!准备移除mysql"
			yum remove mysql-server mysql -y 
		else 
			echo "mysql服务器没有安装"
		fi

		echo "测试PhP服务器是否已经安装"
		php --version &> /dev/null
		if [ $? == 0 ];then 
			echo "php已经安装!!准备移除PHP"
			yum remove php
		else 
			echo "PHP没有安装"
		fi 
		
	else 
		echo "对不起,此系统是32位,无法使用此脚本"
	fi
else
	echo "系统版本不对"
fi	


