FROM debian:bullseye

RUN apt-get update && apt-get install -y php-fpm

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /run/php

CMD ["php-fpm7.4", "-F"]
