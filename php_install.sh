#!/bin/bash

PREFIX=/usr/local
PACK=php-7.1.6.tar.gz
DIR=$(echo $PACK | awk -F'.tar' '{print $1}')
INDEX_DIR=${PREFIX}/apache/htdocs/index.php


yum -y install libxml2 libxml2-devel
yum -y install openssl openssl-devel
yum -y install bzip2-devel


tar -xvf $PACK -C $PREFIX
cd $PREFIX/$DIR
./configure --prefix=/usr/local/php \
	--with-mysql-sock=/usr/local/mysql \
	--with-openssl \
	--with-mysqli=/usr/local/mysql/bin/mysql_config \
	--enable-mbstring \
	--with-freetype-dir \
	--with-jpeg-dir \
	--with-png-dir \
	--with-zlib \
	--with-libxml-dir=/usr \
	--enable-xml  \
	--enable-sockets \
	--with-apxs2=/usr/local/apache/bin/apxs \
	--with-config-file-path=/etc \
	--with-config-file-scan-dir=/etc/php.d \
	--with-bz2  
#	--enable-maintainer-zts

make
make install
cp php.ini-production /etc/php.ini
cd /usr/local/php

create_index(){
	case $1 in
		1)cat <<-EOF > $INDEX_DIR
		  <?php
		     phpinfo();
		  ?>
		  EOF
		  ;;
		2)cat <<-EOF > $INDEX_DIR
		  <?php
		    $mysqli = new mysqli("localhost", "root", "123", "student");
		    if ($mysqli->connect_errno) {
		        echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
		    }
		    echo $mysqli->host_info . "\n";
		    
		    $mysqli = new mysqli("127.0.0.1", "root", "123", "student", 3306);
		    if ($mysqli->connect_errno) {
		        echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
		    }
		    
		    echo $mysqli->host_info . "\n";
		  ?>
	          EOF
		  ;;
	
	esac
}

sed -i "/^mysqli.default_socket/s#=#&/var/lib/mysql/mysql.sock#" php.ini
create_index 2
