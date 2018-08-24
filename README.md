## LAMPAUTO
1. 自动搭建LAMP环境脚本
2. 完成时间2017-11-17
3. 此文档编辑于2017-10-18

## 软件版本
1. Apache2.4.29  
2. MySQL5.5.32  
3. PHP5.5.38

## 脚本安装路径
1. httpd2.4安装路径: /usr/local/httpd24
2. httpd2.4配置文件: /etc/httpd24/httpd.conf
3. mysql5.5安装路径: /usr/local/mysql
4. mysql5.5配置文件: /etc/my.cnf
5. php5.5安装路径:   /usr/local/php
6. php5.5配置文件：  /usr/php.ini  

## 脚本变量
1. 创建目录 /sourcelamp             #源码包目录
2. 创建目录 /sourcemake             #解压的源码包目录
3. 创建文件 ~/.lampinstall.log      #部分日志文件 
4. 创建文件 /var/httpd24/index.php  #apache主页文件
5. 创建文件 /etc/rc.d/init.d/httpd24 #httpd24服务启动脚本
6. 创建文件 /etc/profile.d/lamp.sh  #配置环境变量

## 注意事项
1. 执行脚本的过程中保证网络畅通
2. 如果没有安装epel网络源,请执行yum源配置文件,这样将会使用163yum源
3. 本人测试的机器为:CentOS6.5 64Bit 2H1G 脚本执行耗时:20min+
4. 本人只是提供基本配置测试LAMP环境,是否正确配置,详细配置请自行修改
5. MySQL服务root密码为了测试用修改为123456,请安装并测试完毕后自行修改

## 各个脚本功能
1. yumrepo.sh   #yum源自动配置的脚本
2. lamptest.sh  #安装前的测试脚本,仅能测试系统版本,位数以及各类服务是否安装,如果安装并移除失败,请手动移除AMP服务
3. lampauto.sh  #安装LAMP的脚本
4. lampconfig.sh #LAMP安装后的自动配置脚本
5. /conf        #LAMP中各个配置文件

## 使用方法
```bash
   cd
   git clone https://github.com/Beechoing/lampauto.git
   cd lampauto
   chmod +x *.sh
   ./yumrepo.sh  #如果没有配置epel源执行,如果配置epel源可不执行
   ./lamptest.sh
   ./lampauto.sh
   ./lampconfig.sh
```


