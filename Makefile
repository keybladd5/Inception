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

volumes:
	@if [ ! -d /home/polmarti/data/mariadb ] || [ ! -d /home/polmarti/data/wordpress ]; then \
		mkdir -p /home/polmarti/data; \
		mkdir -p /home/polmarti/data/mariadb; \
		mkdir -p /home/polmarti/data/wordpress; \
		echo "Local volumes mounted (/home/polmarti/data)"; \
	else \
		echo "Local volumes already exists (/home/polmarti/data)"; \
	fi;

ssl:
	@if [ ! -f srcs/requirements/nginx/ssl/polmarti.42.fr.key ] || [ ! -f srcs/requirements/nginx/ssl/polmarti.42.fr.crt ]; then \
        echo "Creating TLS/SSL certificates for Nginx"; \
        mkdir -p srcs/requirements/nginx/ssl; \
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
          -keyout srcs/requirements/nginx/ssl/polmarti.42.fr.key \
         -out srcs/requirements/nginx/ssl/polmarti.42.fr.crt \
          -subj "/C=ES/ST=Catalunya/L=Barcelona/O=42/CN=polmarti.42.fr"; \
    else \
        echo "Certificates already exist. They will not be created again."; \
    fi; 

test: 
	@curl -k https://polmarti.42.fr	

clean:
	@-docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@if [ "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
	@docker network prune -f
	@rm -rf srcs/requirements/nginx/ssl/* 2>/dev/null || true
	@rmdir srcs/requirements/nginx/ssl 2>/dev/null || true
	@sudo rm -rf /home/polmarti/data/*
	@echo "Stopped ps, rm images, volumes and networks";
	
debug: ssl volumes
	@docker compose -f srcs/docker-compose.yml up --build
build: ssl volumes
	@docker compose -f srcs/docker-compose.yml up --build -d
down:
	@docker compose -f srcs/docker-compose.yml down 

.PHONY: volumes ssl test clean debug build down
