#!/bin/sh

set -ex


if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ];	# Checks if the database already exists
then
	MYSQL_ROOT_USER=$(cat /run/secrets/MYSQL_ROOT_USER)
	MYSQL_ROOT_PASSWORD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD)
	MYSQL_USER=$(cat /run/secrets/MYSQL_USER)
	MYSQL_PASSWORD=$(cat /run/secrets/MYSQL_PASSWORD)
	mysql_install_db # Creates /var/lib/mysql directory structure
	mysqld_safe --skip-networking & # Start MySQL service
	sleep 5 # Must wait for database to be ready 
	mysql -u ${MYSQL_ROOT_USER} -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE $MYSQL_DATABASE;" #Creates the specified database
	mysql -e "CREATE USER'$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'" #Creates a new user with access from any host (%)
	mysql -e "GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;" #Grants full permissions to user on the database
	mysql -e "FLUSH PRIVILEGES;" #Updates privileges table immediately
	mysql -e "ALTER USER '${MYSQL_ROOT_USER}'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" #Add root user password (default no pass)
	mysqladmin -u ${MYSQL_ROOT_USER} --password=${MYSQL_ROOT_PASSWORD} shutdown #Shuts down MySQL properly
fi

mysqld_safe #Starts MySQL server in foreground