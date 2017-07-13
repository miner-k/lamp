#!/bin/bash
#
# Author:miner_k
# version 0.1.1
# OS:centos6.5


PACK=mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz
PREFIX=/usr/local/
DIR=$(echo $PACK | awk -F'.tar' '{print $1}')
DATADIR=/var/lib/mysql


# install packages which MySQL depend on
yum install libaio


groupadd mysql
useradd -r -g mysql -s /bin/false mysql
tar -xf $PACK  -C $PREFIX 
cd $PREFIX
ln -sv $DIR  mysql
cd mysql
chown -R mysql:mysql .

# Initialize MySQL 
bin/mysqld --initialize-insecure --user=mysql --datadir=$DATADIR


# Set the mysql configuration file
cat <<-EOF > /etc/my.cnf
[mysqld]
datadir=$DATADIR
socket=$DATADIR/mysql.sock
user=mysql
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
[client]
socket=$DATADIR/mysql.sock 
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF


cp support-files/mysql.server /etc/init.d/mysqld

service mysqld start
