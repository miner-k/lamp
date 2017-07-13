#!/bin/bash
#
#author : miner-k
#os: centos6.5
#version:v0.1.1
#


PREFIX=/usr/local
apr_pkg=apr-1.6.2.tar.gz
apr_util_pkg=apr-util-1.6.0.tar.gz
httpd_pkg=httpd-2.4.26.tar.gz
httpd_config=/etc/httpd


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



unpack $apr_pkg
sed -i "/RM='\$RM/s//& -f/" configure
./configure --prefix=$PREFIX/apr
install

unpack $apr_util_pkg
./configure --prefix=$PREFIX/apr-util --with-apr=$PREFIX/apr
install

unpack $httpd_pkg
./configure --prefix=$PREFIX/apache \
	--sysconfdir=$httpd_config  \
	--enable-so --enable-rewrite \
	--enable-cgid \
	--enable-cgi \
	--enable-modules=most \
	--enable-mods-shared=most \
	--enable-mpms-shared=all \
	--with-apr=$PREFIX/apr \
	--with-apr-util=$PREFIX/apr-util
install

echo 'PidFile "/var/run/httpd.pid"' >> $httpd_config/httpd.conf
sed -i '/mpm_event_module/s/LoadModule/#&/' $httpd_config/httpd.conf
sed -i '/mpm_prefork_module/s/^#//' $httpd_config/httpd.conf

chmod +x httpd
cp httpd /etc/init.d/

chkconfig --add httpd
chkconfig on httpd

service httpd start
