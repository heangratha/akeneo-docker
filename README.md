# Overview
This repository for setup akeneo pim 3.2 with docker on Ubuntu 18.04 LTS

# Requirements
- [composer](https://getcomposer.org/doc/00-intro.md)
- [docker](https://docs.docker.com/install/)
- [nodejs.10](https://github.com/nodesource/distributions/blob/master/README.md#debinstall)
- [yarn](https://classic.yarnpkg.com/en/docs/install/#debian-stable)
- [akeneo](https://docs.akeneo.com/3.2/index.html)

# Installation

1. Create project directory

        mkdir ~/dev
        git clone https://github.com/heangratha/akeneo_pim.git ~/dev/akeneo_pim
        cd ~/dev/akeneo_pim
        wget https://download.akeneo.com/pim-community-standard-v3.2-latest-icecat.tar.gz
        tar -xvzf pim-community-standard-v3.2-latest-icecat.tar.gz -C ~/dev/akeneo_pim/pim

2. Replace LOCAL_USER_ID

        id -u -r
        vi docker-compose.yml

3. Start docker containers

        docker-compose up -d
        docker-compose ps

4. Initializing Akeneo

        docker-compose exec web /bin/bash
        su www-data -s /bin/bash
        composer install --optimize-autoloader --prefer-dist
        yarn install
        php bin/console cache:clear --no-warmup --env=prod
        php bin/console pim:installer:assets --symlink --clean --env=prod
        bin/console pim:install --force --symlink --clean --env=prod
        yarn run webpack

5. Open your favourite browser default login (admin:admin)

        127.0.0.1
