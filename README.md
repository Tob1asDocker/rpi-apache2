# Apache2 (httpd) on Raspberry Pi / ARM

IMPORTANT: This image is not ready yet! There is still a lot to do. (e.g. own SSL certificates, http to https forwarding, own conf/mods/ssl (folder))

### Supported tags
-	[`latest` (*Dockerfile*)](https://github.com/Tob1asDocker/rpi-apache2/blob/master/stretch.armhf.Dockerfile) (*It always uses the latest Apache2 version contained in raspbian.*)

### What is Apache2 (httpd)?
The Apache HTTP Server, colloquially called Apache, is a Web server application notable for playing a key role in the initial growth of the World Wide Web. Originally based on the NCSA HTTPd server, development of Apache began in early 1995 after work on the NCSA code stalled. Apache quickly overtook NCSA HTTPd as the dominant HTTP server, and has remained the most popular HTTP server in use since April 1996.
> [wikipedia.org/wiki/Apache_HTTP_Server](https://en.wikipedia.org/wiki/Apache_HTTP_Server) and [httpd.apache.org](https://httpd.apache.org/)

![logo](https://raw.githubusercontent.com/docker-library/docs/master/httpd/logo.png)

### How to use this image
* ``` $ docker pull tobi312/rpi-apache2 ```
* Optional: ``` $ mkdir -p /home/pi/html ```
* ``` $ docker run --name httpd -p 80:80 -p 443:443 -v /home/pi/html:/var/www/html --link some-php-fpm-container:phpfpm -e ENABLE_PROXY_FCGI=true -e ENABLE_PROXY_HTML=true -e ENABLE_SSL=true -e ENABLE_REWRITE=true -e ALLOWOVERRIDE=true -d tobi312/rpi-apache2 ``` 

### Environment Variables
* `TZ` (Default: Europe/Berlin)
* `ENABLE_PROXY_HTTP`
	* `ENABLE_PROXY_HTML`
* `ENABLE_PROXY_FCGI`
* `ENABLE_REWRITE`
* `ENABLE_SSL`
* `ALLOWOVERRIDE`
* `REMOTEIP` (set 1 to enable, use this only behind a proxy!)


### You need PHP (PHP-FPM)?, see here: 
* [DockerHub](https://hub.docker.com/r/tobi312/rpi-php/)
* [GitHub](https://github.com/TobiasH87Docker/rpi-php)

### This Image on
* [DockerHub](https://hub.docker.com/r/tobi312/rpi-apache2/)
* [GitHub](https://github.com/TobiasH87Docker/rpi-apache2)
