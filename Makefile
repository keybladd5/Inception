# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: polmarti <polmarti@student.42barcelon      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/05/22 11:55:41 by polmarti          #+#    #+#              #
#    Updated: 2025/05/22 11:55:43 by polmarti         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


nginx:
	@if [ "$$(docker ps -q -f name=nginx-test)" ]; then \
		echo "El contenedor 'nginx-test' ya está corriendo."; \
	elif [ "$$(docker ps -aq -f name=nginx-test)" ]; then \
		echo "El contenedor 'nginx-test' existe pero está parado. Reiniciando..."; \
		docker start nginx-test; \
	else \
		echo "Creando certificados TSL para Nginx"; \
		mkdir -p srcs/requirements/nginx/ssl; \
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  		-keyout srcs/requirements/nginx/ssl/polmarti.42.fr.key \
 		-out srcs/requirements/nginx/ssl/polmarti.42.fr.crt \
  		-subj "/C=ES/ST=Catalunya/L=Barcelona/O=42/CN=polmarti.42.fr"; \
		echo "Creando y lanzando el contenedor 'nginx-test'..."; \
		docker build -t nginx-test ./srcs/requirements/nginx/ && \
		docker run -d --name nginx-test -p 80:80 -p 443:443 nginx-test; \
	fi

nginx-test: nginx
	curl -k http://polmarti.42.fr
	curl -k https://polmarti.42.fr	
	docker exec -it nginx-test bash

clean:
	-docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa | grep -v 'bridge\|host\|none');\
	docker volume rm $$(docker volume ls -q | grep -v 'bridge\|host\|none');\
	docker network rm $$(docker network ls -q | grep -v 'bridge\|host\|none');
	rm -rf srcs/requirements/nginx/conf/ssl/*; \
	rmdir  srcs/requirements/nginx/conf/ssl
build:
	docker compose -f ./srcs/docker-compose.yml up --build
.PHONY: nginx nginx-test clean
