#!/bin/bash

# Get source packages of LAMP
# Apache 2.4.26 + MySQL 5.7.17(general bin) + PHP 7.1.6


SING=0
function get_Apache(){
	#wget http://mirror.bit.edu.cn/apache//httpd/httpd-2.4.26.tar.gz
	wget http://mirror.bit.edu.cn/apache//httpd/httpd-2.4.27.tar.gz
	SING=$($SING+$?)
	wget http://mirror.bit.edu.cn/apache//apr/apr-util-1.6.0.tar.gz
	SING=$($SING+$?)
	wget http://mirror.bit.edu.cn/apache//apr/apr-1.6.2.tar.gz
	SING=$($SING+$?)

}

function get_MySQL_Bin(){
	wget https://downloads.mysql.com/archives/get/file/mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz --no-check-certificate
	SING=$($SING+$?)
}

function get_PHP(){
	#wget http://cn2.php.net/get/php-7.1.6.tar.gz/from/this/mirror
	wget http://am1.php.net/distributions/php-7.0.21.tar.gz
	SING=$($SING+$?)
}

function install_Dev_Tools(){
	yum -y groupinstall "Development tools"
	SING=$($SING+$?)
}

function last_step_suc(){
	if [ $SING -ne 0 ];then
		echo $1
		$SING=0
		exit 1
	fi
}

get_Apache
last_step_suc " download apache failed ..."
get_MySQL_Bin
last_step_suc " download MySQL failed ..."
get_PHP
last_step_suc " download PHP failed ..."
install_Dev_Tools
last_step_suc " install Development tools failed ..."
