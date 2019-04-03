FROM balenalib/rpi-raspbian:stretch

LABEL org.opencontainers.image.authors="Tobias Hargesheimer <docker@ison.ws>" \
	org.opencontainers.image.title="Apache2" \
	org.opencontainers.image.description="Debian 9 Stretch with Apache2 on arm arch" \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.url="https://hub.docker.com/r/tobi312/rpi-apache2" \
	org.opencontainers.image.source="https://github.com/Tob1asDocker/rpi-apache2"

ARG CROSS_BUILD_START=":"
ARG CROSS_BUILD_END=":"

ENV LANG C.UTF-8
ENV TZ Europe/Berlin
ENV TERM xterm
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN [ ${CROSS_BUILD_START} ]

RUN apt-get update && apt-get install -y \
	nano \
	patch \
	zip unzip \
	wget \
	curl \
	openssl \
	apache2 apache2-doc apache2-utils \
	#libapache2-mod-proxy-html \
	#libapache2-mod-fcgid \
	--no-install-recommends && \
	rm -rf /var/lib/apt/lists/* && \
	rm /var/www/html/index.html

RUN sed -ri -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' "/etc/apache2/apache2.conf" && \
	sed -ri -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' "/etc/apache2/sites-available/000-default.conf" && \
	sed -ri -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' "/etc/apache2/sites-available/default-ssl.conf"
	
COPY entrypoint_stretch.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /var/www/html /etc/ssl/ /etc/apache2/sites-enabled /etc/apache2/conf-enabled /etc/apache2/mods-enabled
EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

RUN [ ${CROSS_BUILD_END} ]