#!/bin/bash


#PREFIX=/usr/local
#PHP_PACK=php-7.1.6.tar.gz
#INDEX_PHP_DIR=${PREFIX}/apache/htdocs/index.php
#HTTPD_CONFIG=/etc/httpd/httpd.conf

PHP_DIR=$(echo $PHP_PACK | awk -F'.tar' '{print $1}')

yum -y install libxml2 libxml2-devel
yum -y install openssl openssl-devel
yum -y install bzip2-devel


tar -xvf $PHP_PACK -C $PREFIX
cd $PREFIX/$PHP_DIR
./configure --prefix=$PREFIX/php \
	--with-mysql-sock=$PREFIX/mysql \
	--with-openssl \
	--with-mysqli=$PREFIX/mysql/bin/mysql_config \
	--enable-mbstring \
	--with-freetype-dir \
	--with-jpeg-dir \
	--with-png-dir \
	--with-zlib \
	--with-libxml-dir=/usr \
	--enable-xml  \
	--enable-sockets \
	--with-apxs2=$PREFIX/apache/bin/apxs \
	--with-config-file-path=/etc \
	--with-config-file-scan-dir=/etc/php.d \
	--with-bz2  
#	--enable-maintainer-zts

make
make install
cp php.ini-production /etc/php.ini
cd $PREFIX/php

create_index(){
	case $1 in
		one)cat <<-EOFF > $INDEX_PHP_DIR
		    <?php
		       phpinfo();
		    ?>
EOFF
		    ;;
		two)cat <<-EOF > $INDEX_PHP_DIR
		    <?php
		     \$mysqli = new mysqli("localhost", "root", "","mysql");
		      if (\$mysqli->connect_errno) {
		          echo "Failed to connect to MySQL: (" . \$mysqli->connect_errno . ") " . \$mysqli->connect_error;
		      }
		      echo \$mysqli->host_info . "\n";
		      
		      \$mysqli = new mysqli("127.0.0.1", "root", "", "mysql", 3306);
		      if (\$mysqli->connect_errno) {
		          echo "Failed to connect to MySQL: (" . \$mysqli->connect_errno . ") " . \$mysqli->connect_error;
		      }
		      
		      echo \$mysqli->host_info . "\n";
		    ?>
EOF
		  ;;
	
	esac
}

sed -i "/^mysqli.default_socket/s#=#&/var/lib/mysql/mysql.sock#" /etc/php.ini

create_index two


sed -i '/DirectoryIndex /s//& index.php /' $HTTPD_CONFIG
sed -i '/AddType.*.gz /a AddType application/x-httpd-php-source .phps' $HTTPD_CONFIG
sed -i '/AddType.*.gz /a AddType application/x-httpd-php .php' $HTTPD_CONFIG

service httpd restart
