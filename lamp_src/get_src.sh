#!/bin/bash

# Get source packages of LAMP
# Apache 2.4.26 + MySQL 5.7.17(general bin) + PHP 7.1.6

function get_Apache(){
	wget http://mirror.bit.edu.cn/apache//httpd/httpd-2.4.26.tar.gz
	wget http://mirror.bit.edu.cn/apache//apr/apr-util-1.6.0.tar.gz
	wget http://mirror.bit.edu.cn/apache//apr/apr-1.6.2.tar.gz

}

function get_MySQL_Bin(){
	wget https://downloads.mysql.com/archives/get/file/mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz --no-check-certificate
}

function get_PHP(){
	wget http://cn2.php.net/get/php-7.1.6.tar.gz/from/this/mirror
}

function install_Dev_Tools(){
	yum -y groupinstall "Development tools"
}

get_Apache
get_MySQL_Bin
get_PHP
install_Dev_Tools
