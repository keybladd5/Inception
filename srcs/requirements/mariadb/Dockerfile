FROM debian:bullseye:stable

RUN apt-get update && apt-get install -y mariadb-server && apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN service mariadb start
#RUN mysql -u root o ENTRYPOINT [ "mysql -u root" ]?