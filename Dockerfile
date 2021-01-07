FROM php:7.3

RUN apt-get update && apt-get install -qqy git unzip libfreetype6-dev libjpeg62-turbo-dev libpng-dev libaio1 wget && apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/ 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN mkdir /opt/oracle && cd /opt/oracle
ADD instantclient-basic-linux.x64-21.1.0.0.0.zip /opt/oracle
ADD instantclient-sdk-linux.x64-21.1.0.0.0.zip /opt/oracle
RUN  unzip /opt/oracle/instantclient-basic-linux.x64-21.1.0.0.0.zip -d /opt/oracle && unzip /opt/oracle/instantclient-sdk-linux.x64-21.1.0.0.0.zip -d /opt/oracle && rm -rf /opt/oracle/*.zip
ENV LD_LIBRARY_PATH  /opt/oracle/instantclient_21_1:${LD_LIBRARY_PATH}
RUN echo 'instantclient,/opt/oracle/instantclient_21_1/' | pecl install oci8-2.2.0 && docker-php-ext-enable oci8 && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient_21_1,21.1 && docker-php-ext-install pdo_oci
