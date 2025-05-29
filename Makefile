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
		echo "Creando y lanzando el contenedor 'nginx-test'..."; \
		docker build -t nginx-test ./srcs/requirements/nginx/ && \
		docker run -d --name nginx-test -p 80:80 nginx-test; \
	fi

nginx-test: nginx
	docker exec -it nginx-test bash

clean:
	docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\
	docker network rm $$(docker network ls -q);\	

.PHONY: nginx nginx-test clean