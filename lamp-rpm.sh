#!/bin/bash
#
#author : miner_k
#version: v 0.1.1
#OS : centos6.8
#


yum -y install httpd

yum -y install php php-mbstring php-mysql

yum -y install mysql-server  mysql

service httpd start

service mysqld start

mysql -e "SET PASSWORD FOR 'root'@'localhost'=PASSWORD('123');"
mysql -e "flush privileges;"

cat <<-EOF > /var/www/html/index.php
<?php
  $conn=mysql_connect('localhost','root','redhat');
  if ($conn)
    echo "Success...";
  else
    echo "Failure...";
?>
EOF
