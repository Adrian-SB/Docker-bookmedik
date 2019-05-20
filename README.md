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
