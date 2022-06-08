#!/usr/bin/env bash

## Nginx
sudo apt-get -y update
sudo apt-get -y install nginx

## Mysql - MariaDB
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< "maria-db-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "maria-db-server mysql-server/root_password_again password root"
sudo apt-get -q -y install mariadb-server

## PHP
sudo add-apt-repository ppa:ondrej/php
sudo apt-get -y update
sudo apt-get -y install php8.0-fpm php8.0-mbstring php8.0-zip php8.0-intl php8.0-xml php8.0-curl php8.0-dev nfs-common php8.0-cli php8.0-mysql php8.0-gd php8.0-imagick php8.0-tidy php8.0-xmlrpc
sudo pecl channel-update pecl.php.net
sudo pecl install xdebug

## Phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password root"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password root"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password root"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin
sudo ln -s /usr/share/phpmyadmin /vagrant
sudo phpenmod mcrypt

## Install wp-cli
curl -L https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/bin/wp

## MySql
mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS db_main"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON db_main.* TO 'db_user'@'localhost' IDENTIFIED BY 'db_pass'"
mysql -uroot -proot -e "FLUSH PRIVILEGES"

cat <<EOT >> /etc/php/8.0/fpm/php.ini
[xdebug]
zend_extension=/usr/lib/php/20170718/xdebug.so
xdebug.remote_enable=1
xdebug.remote_host=10.2.2
xdebug.remote_port=9000
EOT

sudo sed -i -r -e  's/^(upload_max_filesize).*/\1=64M/g' -e 's/^(post_max_size).*/\1=128M/g' /etc/php/8.0/fpm/php.ini

sudo service php8.0-fpm restart

cat > /etc/nginx/sites-available/default.vhost <<EOF
server {
	listen 80;
	listen [::]:80;

	root /vagrant/web;

	index index.php index.html index.htm index.nginx-debian.html;
	server_name $2;

	client_max_body_size 100M;

	 location / {
      try_files \$uri/index.html \$uri \$uri/ /index.php?\$args;
      add_header Last-Modified \$date_gmt;
      add_header Cache-Control 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
              sendfile off;
      if_modified_since off;
      expires off;
      etag off;
      proxy_no_cache 1;
      proxy_cache_bypass 1;
  }
  location ^~ /admin {
          try_files \$uri \$uri/ /index.php?\$query_string;
  }

  location ^~ /cpresources {
          try_files \$uri \$uri/ /index.php?\$query_string;
  }

  location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_param  SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
		fastcgi_pass unix:/run/php/php8.0-fpm.sock;
	}

  location ~ /\.ht {
          deny all;
  }

	location ~ /\.ht {
		deny all;
	}
}
EOF

ln -sf /etc/nginx/sites-available/default.vhost /etc/nginx/sites-enabled/default.vhost

#sudo openssl req -nodes -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -subj '/CN=localhost'

curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

sudo service nginx restart