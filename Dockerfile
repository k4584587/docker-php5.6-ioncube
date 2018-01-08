 FROM php:5.6-apache
RUN apt-get update && \
            apt-get install -y libfreetype6-dev libjpeg62-turbo-dev && \
            docker-php-ext-install mysqli && \
            docker-php-ext-install mbstring && \
            docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/  &&  \
            docker-php-ext-install gd
            
RUN chmod 777 -R /var/www

# ioncube loader
RUN curl -fsSL 'http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz' -o ioncube.tar.gz \
    && mkdir -p ioncube \
    && tar -xf ioncube.tar.gz -C ioncube --strip-components=1 \
    && rm ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.6.so /var/www/ioncube_loader_lin_5.6.so \
    && rm -r ioncube

#server time set
ENV TZ Asia/Seoul
RUN apt-get install -y tzdata \
  && rm -rf /var/lib/apt/lists/* \
  && echo "${TZ}" > /etc/timezone \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

RUN a2enmod rewrite

ADD scripts/chmod.sh /chmod.sh

# php.ini
COPY config/php.ini /usr/local/etc/php/