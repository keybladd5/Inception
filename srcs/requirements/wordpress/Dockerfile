FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends php-fpm

COPY www.conf /etc/php/7.4/fpm/pool.d/.

RUN mkdir -p /run/php

CMD ["php-fpm7.4", "-F"]
