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

ssl:
	@if [ ! -f requirements/nginx/ssl/polmarti.42.fr.key ] || [ ! -f requirements/nginx/ssl/polmarti.42.fr.crt ]; then \
        echo "Creando certificados TSL para Nginx"; \
        mkdir -p requirements/nginx/ssl; \
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
          -keyout requirements/nginx/ssl/polmarti.42.fr.key \
         -out requirements/nginx/ssl/polmarti.42.fr.crt \
          -subj "/C=ES/ST=Catalunya/L=Barcelona/O=42/CN=polmarti.42.fr"; \
    else \
        echo "Los certificados ya existen. No se crearán nuevamente."; \
    fi; 

nginx: ssl
	@if [ "$$(docker ps -q -f name=nginx-test)" ]; then \
		echo "El contenedor 'nginx-test' ya está corriendo."; \
	elif [ "$$(docker ps -aq -f name=nginx-test)" ]; then \
		echo "El contenedor 'nginx-test' existe pero está parado. Reiniciando..."; \
		docker start nginx-test; \
		docker build -t nginx-test .requirements/nginx/ && \
		docker run -d --name nginx-test -p 80:80 -p 443:443 nginx; \
	fi

nginx-test: 
	@curl -k http://polmarti.42.fr
	@curl -k https://polmarti.42.fr	
	@docker exec -it nginx bash

clean:
	@-docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@if [ "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
	@docker network prune -f
	@rm -rf requirements/nginx/ssl/* 2>/dev/null || true
	@rmdir requirements/nginx/ssl 2>/dev/null || true
	@echo "Stoped ps, rm images, volumes and networks";
	
build: ssl
	@docker compose up --build

.PHONY: nginx nginx-test clean
