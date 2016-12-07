#!/bin/bash

if [ ! -z "$TZ" ]; then
	echo ">> set timezone"
	echo ${TZ} >/etc/timezone && dpkg-reconfigure -f noninteractive tzdata
fi

if [ ! -z "$ENABLE_PROXY_HTTP" ] || [ ! -z "$ENABLE_PROXY_HTML" ] || [ ! -z "$ENABLE_PROXY_FCGI" ]; then
	echo ">> enabling proxy support"
	/usr/sbin/a2enmod proxy
	if [ ! -z "$ENABLE_PROXY_HTTP" ] || [ ! -z "$ENABLE_PROXY_HTML" ]; then
		echo ">> enabling HTTP proxy support"
		/usr/sbin/a2enmod proxy_http
	fi
	if [ ! -z "$ENABLE_PROXY_HTML" ]; then
		echo ">> enabling HTML proxy support"
		/usr/sbin/a2enmod xml2enc
		/usr/sbin/a2enmod proxy_html
	fi	
	if [ ! -z "$ENABLE_PROXY_FCGI" ]; then
		echo ">> enabling FastCGI proxy support"
		/usr/sbin/a2enmod proxy_fcgi
		
		cat > /etc/apache2/conf-available/php5-fpm.conf <<EOF
<IfModule mod_proxy_fcgi.c>
	<FilesMatch ".+\.ph(p[345]?|t|tml)$">
		# SetHandler "proxy:unix:/var/run/php5-fpm.sock|fcgi://localhost/"
		SetHandler proxy:fcgi://phphost:9000
	</FilesMatch>
</IfModule>

EOF
		
		/usr/sbin/a2enconf php5-fpm
		#echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
	fi
fi

if [ ! -z "$ENABLE_REWRITE" ]; then
	echo ">> enabling rewrite support"
	/usr/sbin/a2enmod rewrite
	#/usr/sbin/a2enmod actions
fi

if [ ! -z "$ENABLE_SSL" ]; then
	echo ">> enabling SSL support"
	/usr/sbin/a2ensite default-ssl
	/usr/sbin/a2enmod ssl
	#/usr/sbin/a2enmod headers
	
	if [ ! -e "/etc/ssl/private/ssl-cert-snakeoil.key" ] || [ ! -e "/etc/ssl/certs/ssl-cert-snakeoil.pem" ]; then
		echo ">> generating self signed cert"
		openssl req -x509 -newkey rsa:4086 -subj "/C=/ST=/L=/O=/CN=localhost" -keyout "/etc/ssl/private/ssl-cert-snakeoil.key" -out "/etc/ssl/certs/ssl-cert-snakeoil.pem" -days 3650 -nodes -sha256
	fi
fi

if [ ! -z "$ALLOWOVERRIDE" ]; then
	echo ">> set AllowOverride form none to all"
	# diff -uNr /etc/apache2/apache2.conf /etc/apache2/apache2.conf.txt > /etc/apache2/apache2.conf.diff
	
	cat > /etc/apache2/apache2.conf.diff <<EOF
--- /etc/apache2/apache2.conf	2016-12-06 17:12:19.000000000 +0100
+++ /etc/apache2/apache2.conf.txt	2016-12-06 18:28:08.000000000 +0100
@@ -162,8 +162,8 @@
 </Directory>
 
 <Directory /var/www/>
-	Options Indexes FollowSymLinks
-	AllowOverride None
+	Options FollowSymLinks
+	AllowOverride All
 	Require all granted
 </Directory>
 

EOF
	
	patch /etc/apache2/apache2.conf < /etc/apache2/apache2.conf.diff
fi

# exec CMD
echo ">> exec docker CMD"
echo "$@"
exec "$@"
