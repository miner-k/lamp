#!/bin/bash

# Apache config
# HTTP_CONF=/etc/httpd/httpd.conf
# FPM_IP=127.0.0.1

sed -i '/mod_proxy.so/s/#//' $HTTP_CONF
sed -i '/mod_proxy_fcgi.so/s/#//' $HTTP_CONF

sed -i "/^#ServerName/a ProxyPassMatch ^/(.*\.php)$ fcgi://$FPM_IP:9000$WEB_DATA/\$1" $HTTP_CONF
sed -i '/^#ServerName/a ProxyRequests Off' $HTTP_CONF
sed -i '/ DirectoryIndex /s//& index.php /' $HTTP_CONF

service httpd restart
