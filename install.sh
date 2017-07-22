#!/bin/bash
#
# Author:miner_k
# Version:0.0.1
# 


menu(){
	clear
	cat <<-EOF
	##############################################################
	If all are executed on a server at steps 1, 2, 3, 4 steps

	1.get packages of LAMP(apache2.4.27 + MySQL5.7.17 + PHP 7.0)
	2.install apache
	3.install MySQL
	4.install PHP(module)
	5.install PHP-fpm
	6.modify the Apache configuration file
	7.Load environment variables
	q.exit
	##############################################################
	EOF
}

source config
while :
do
	menu
	
	read -p "输入对应的编号：" num
	case $num in
		1) bash get_src.sh
		;;

		2) bash apache_src.sh
		;;
		3) bash mysqld_bin.sh
		;;
		4) bash php_install.sh
		;;
		5) bash php-fpm.sh
		;;
		6) bash apache_php-fpm.sh
		;;
		7) bash create_porfile.sh
		;;
		q) exit 0
		;;
		*)
		echo "输入错误" ;;
	esac 
done


