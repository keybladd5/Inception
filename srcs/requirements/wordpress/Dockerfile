FROM debian:bullseye

RUN apt-get update && apt-get install -y php7.4-fpm php7.4-mysqli curl

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN sed -i 's|pm.min_spare_servers = 1|pm.min_spare_servers = 2|' /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /run/php && chmod 775 /run/php

# Download WordPress CLI tool
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Make WP-CLI executable and mv to standard bin route
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/wordpress.sh /usr/local/bin

RUN chmod 777 /usr/local/bin/wordpress.sh

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]

#El flag "-F" lanza el servicio en primer plano = pid 1
#CMD ["php-fpm7.4", "-F"] 
