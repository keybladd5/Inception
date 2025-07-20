#!/bin/sh

#exit the script if any command fails 
set -ex

# Navigate to web server root directory
cd /var/www/html

# Download WordPress core files
if [ ! -f /var/www/html/wp-settings.php ]; then
	wp core download --allow-root
fi

# Create WordPress configuration with database settings
if [ ! -f /var/www/html/wp-config.php ]; then
	wp config create --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=${MYSQL_HOSTNAME} --allow-root
fi

# Complete WordPress installation with site settings and admin data
if ! wp core is-installed --allow-root; then
	wp core install --url=${DOMAIN_NAME} --title=inception --admin_user=${WORDPRESS_ADMIM} --admin_password=${WORDPRESS_ADMIM_PASS} --admin_email=${WORDPRESS_ADMIM_EMAIL} --allow-root
	# End WordPress installation with user creation
	wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASS --allow-root
fi

#El flag "-F" lanza el servicio en primer plano = pid 1
php-fpm7.4 -F