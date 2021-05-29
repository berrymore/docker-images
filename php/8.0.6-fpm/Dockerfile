FROM php:8.0.6-fpm AS base

RUN apt-get update && \
	apt-get -y install libxml2-dev libicu-dev libmemcached-dev libyaml-dev libmpdec-dev libcurl4-openssl-dev libssl-dev libzip-dev && \
	cd /tmp && \
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	php composer-setup.php --filename=composer --install-dir=/usr/bin && \
	rm -rf /tmp/* && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install bcmath zip intl soap pdo_mysql sockets opcache && \
	pecl install -s xdebug-3.0.4 apcu yaml decimal memcached && \
	docker-php-ext-enable xdebug apcu yaml decimal memcached

RUN echo "memory_limit = -1" >> /usr/local/etc/php/php.ini && \
	echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
	echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini