FROM php:7.0-apache

RUN apt-get update && apt-get -y upgrade && apt-get -y install git
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN mkdir /var/www/bookmedik

EXPOSE 80

ADD book.conf /etc/apache2/sites-enabled/

RUN git clone https://github.com/evilnapsis/bookmedik.git && cp -r bookmedik /var/www/

COPY Database.php /var/www/bookmedik/core/controller/Database.php

CMD /usr/sbin/apache2ctl -D FOREGROUND
