FROM debian:stretch-slim

ENV TZ=Asia/Phnom_Penh
ENV PHP_VERSION=7.2
RUN apt-get -qq update && \
    apt-get -yqq install apt-transport-https lsb-release ca-certificates wget curl gnupg && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list && \
    apt-get -qq update && apt-get -qqy upgrade && apt-get -q autoclean && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && \
            DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            make \
            apache2 \
            locales \
            curl \
            bzip2 \
            openssl \
            less \
            yarn \
            php-apcu php$PHP_VERSION-dev libmcrypt-dev php-pear\
            php$PHP_VERSION-fpm php$PHP_VERSION-apcu php$PHP_VERSION-imagick \
            php$PHP_VERSION-bcmath php$PHP_VERSION-bz2 php$PHP_VERSION-cli php$PHP_VERSION-common php$PHP_VERSION-curl \
            php$PHP_VERSION-gd php$PHP_VERSION-imap php$PHP_VERSION-interbase php$PHP_VERSION-intl php$PHP_VERSION-json \
            php$PHP_VERSION-mbstring php$PHP_VERSION-mysql php$PHP_VERSION-opcache php$PHP_VERSION-readline php$PHP_VERSION-soap \
            php$PHP_VERSION-xml php$PHP_VERSION-xmlrpc php$PHP_VERSION-xsl php$PHP_VERSION-zip

## Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

## Install composer
RUN wget https://getcomposer.org/download/1.9.2/composer.phar -O /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

## Install php libmcrypt
RUN pecl channel-update pecl.php.net
RUN echo '' | pecl install mcrypt-1.0.1
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN a2enmod actions alias expires headers rewrite proxy_fcgi ssl
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ADD docker/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD docker/php.ini /etc/php/7.2/cli/php.ini
ADD docker/php.ini /etc/php/7.2/fpm/php.ini
ADD docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
