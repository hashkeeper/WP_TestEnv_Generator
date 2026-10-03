#!/bin/bash

if [ -z ${1} ]; then
  exit 0
fi

mkdir ./${1} && cd ./${1}

tee podman-compose.yml > /dev/null <<'EOF'
services:
  wordpress:
    image: docker.io/library/wordpress:latest
    container_name: WP_Test
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppass
    volumes:
      - ./my-theme:/var/www/html/wp-content/themes/test-theme:Z
    depends_on:
      - db

  db:
    image: docker.io/library/mariadb:latest
    container_name: WP_Test_DB
    restart: unless-stopped
    environment:
      MARIADB_ROOT_PASSWORD: rootpass
      MARIADB_DATABASE: wordpress
      MARIADB_USER: wpuser
      MARIADB_PASSWORD: wppass
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
EOF