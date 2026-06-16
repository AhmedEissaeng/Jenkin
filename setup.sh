#!/bin/bash

set -e

echo "Updating packages..."
apt update

echo "Installing base packages..."
apt install -y unzip git curl php-cli

echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

echo "Installing PHP XML extension..."
apt install -y php8.4-xml

echo "Verifying XML modules..."
php -m | grep -E "dom|xml"

echo "Installing PHP MySQL extension..."
apt install -y php8.4-mysql

echo "Verifying MySQL PHP module..."
php -m | grep mysql
