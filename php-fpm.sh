#!/bin/bash

yum -y install libxml2 libxml2-devel openssl openssl-devel bzip2-devel
yum -y groupinstall "Development Tools"

tar -xvf php-7.1.6.tar.gz
cd php-7.1.6
 ./configure --prefix=/usr/local/php \
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
	--with-config-file-path=/etc \
	--with-config-file-scan-dir=/etc/php.d \
	--with-bz2 \
	--enable-fpm

make 
make install
cp php.ini-production /etc/php.ini
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
chkconfig --add php-fpm

cd /usr/local/php/
cp etc/php-fpm.conf{.default,}
cp php-fpm.d/www.conf{.default,}


sed -i '/^listen/s/127.0.0.1/0.0.0.0/' /usr/local/php/etc/php-fpm.d/www.conf

mkdir /www/

cat <<-EOF > /www/index.php
<?php
phpinfo();
?>
EOF


service php-fpm start



# Apache config
HTTP_CONF=/etc/httpd/httpd.conf

sed -i '/mod_proxy.so/s/#//' $HTTP_CONF
sed -i '/mod_proxy_fcgi.so/s/#//' $HTTP_CONF

sed -i '/^ServerName/a ProxyPassMatch ^/(.*\.php)$ fcgi://FPM_IP:9000/var/www/$1' $HTTP_CONF
sed -i '/^ServerName/a ProxyRequests Off' $HTTP_CONF
sed -i '/ DirectoryIndex /s//& index.php /' $HTTP_CONF

service httpd start

