#!/bin/bash
#
#author : miner-k
#os: centos6.5
#version:v0.1.1
#


#PREFIX=/usr/local
#APR_PKG=apr-1.6.2.tar.gz
#APR_UTIL_PKG=apr-util-1.6.0.tar.gz
#HTTPD_PKG=httpd-2.4.26.tar.gz
#HTTPD_CONFIG_DIR=/etc/httpd


#  Httpd depend on the packages
yum -y install pcre-devel
yum -y install expat-devel

unpack(){
	tar -xf $1
	dir=$(echo $1 | awk -F'.tar' '{print $1}')
	cd $dir
}

install(){
	make
	make install
	cd ..
}



unpack $APR_PKG
sed -i "/RM='\$RM/s//& -f/" configure
./configure --prefix=$PREFIX/apr
install

unpack $APR_UTIL_PKG
./configure --prefix=$PREFIX/apr-util --with-apr=$PREFIX/apr
install

unpack $HTTPD_PKG
./configure --prefix=$PREFIX/apache \
	--sysconfdir=$HTTPD_CONFIG_DIR  \
	--enable-so --enable-rewrite \
	--enable-cgid \
	--enable-cgi \
	--enable-modules=most \
	--enable-mods-shared=most \
	--enable-mpms-shared=all \
	--with-apr=$PREFIX/apr \
	--with-apr-util=$PREFIX/apr-util
install

echo 'PidFile "/var/run/httpd.pid"' >> $HTTPD_CONFIG_DIR/httpd.conf
sed -i '/mpm_event_module/s/LoadModule/#&/' $HTTPD_CONFIG_DIR/httpd.conf
sed -i '/mpm_prefork_module/s/^#//' $HTTPD_CONFIG_DIR/httpd.conf

chmod +x httpd
cp httpd /etc/init.d/

chkconfig --add httpd
chkconfig on httpd

service httpd start
