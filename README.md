# Docker-bookmedik
Realización de varios ejercicios utilizando Docker junto con la app bookmedik.

*Contenedor de mariadb1*
<pre>
docker run --name mariadb1 -h mariadb \
 -v /home/debian/Backup:/var/lib/mysql \
 -e MYSQL_ROOT_PASSWORD=root \
 -e MYSQL_DATABASE=bookmedik \
 -e MYSQL_USER=admin \
 -e MYSQL_PASSWORD=admin \
 -d mariadb:latest 
</pre> 
Importar esquemas y datos a bookmedik
<pre>
cat schema.sql | docker exec -i mariadb1 /usr/bin/mysql -u admin --password=admin bookmedik
</pre>
Exportar datos
<pre>
docker exec mariadb1 /usr/bin/mysqldump -u root --password=root bookmedik > /home/debian/Backup/Datos/backup.sql
</pre>
*Dockerfile* 
<pre>
FROM php:7.0-apache

RUN apt-get update && apt-get -y upgrade && apt-get -y install git
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN mkdir /var/www/bookmedik

EXPOSE 80

ADD book.conf /etc/apache2/sites-enabled/

RUN git clone https://github.com/evilnapsis/bookmedik.git && cp -r bookmedik /var/www/

COPY Database.php /var/www/bookmedik/core/controller/Database.php

CMD /usr/sbin/apache2ctl -D FOREGROUND
</pre>

Iniciar contenedor a partir del dockerfile

<pre>
docker run --name bookmedik1 -h bookmedik --link mariadb1 -v /home/debian/Logs:/var/log/apache2 -d -p 80:80 bookmedik:1.0
</pre>

Docker-compose

<pre>
version: '3'
services:
  mariadb1:
    image: mariadb:latest
    container_name: mariadb1
    hostname: mariadb
    volumes:
      - ./Backup:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=bookmedik
      - MYSQL_USER=admin
      - MYSQL_PASSWORD=admin

  apache2:
    image: bookmedik:1.0
    container_name: bookmedik1
    hostname: bookmedik
    volumes:
      - ./Logs:/var/log/apache2
    ports:
      - "80:80"
    links:
      - mariadb1
    depends_on:
      - mariadb1
</pre>
