#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


docker run --rm -v ${DIR}/..:/app composer/composer:1.1 create-project --verbose --stability dev --no-interaction --no-install drupal-composer/drupal-project:8.x-dev drupal

source ${DIR}/dcomposer.sh config repositories.0 composer https://packages.drupal.org/8

sed -i -e 's/web/docroot/g' ${DIR}/../drupal/composer.json

source ${DIR}/dcomposer.sh update --prefer-dist
