FROM ubuntu:16.04

RUN apt-get update

# basic packages
RUN apt-get install -y gnupg net-tools wget

# php
RUN apt-get install -y php php-fpm php-pgsql
RUN mkdir /run/php
COPY config/fpm.sh /root/fpm.sh
RUN echo "php_admin_flag[log_errors] = on" >> /etc/php/7.0/fpm/pool.d/www.conf
RUN echo "catch_workers_output = yes" >> /etc/php/7.0/fpm/pool.d/www.conf
RUN echo "php_admin_value[error_log] = /media/persistent/log/fpm.err.log" >> /etc/php/7.0/fpm/pool.d/www.conf
RUN echo "clear_env = no" >> /etc/php/7.0/fpm/pool.d/www.conf

# postgresql install
COPY config/postgresql.asc /root/postgresql.asc
RUN apt-key add /root/postgresql.asc
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" | tee -a /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y postgresql-9.6

# postgresql run
COPY config/postgresql_ctl.sh /root/postgresql_ctl.sh
RUN locale-gen en_US.UTF-8

# supervisor
RUN apt-get install -y supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# nodejs install
RUN wget https://deb.nodesource.com/setup_6.x -O /root/node.sh
RUN chmod +x /root/node.sh
RUN /root/node.sh
RUN apt-get install -y nodejs

# nodejs run
RUN npm install -g nodemon@1.10.0
RUN npm install -g babel-cli@6.16.0
RUN npm install -g babel-preset-es2015@6.16.0
RUN npm install -g babel-preset-stage-2@6.17.0
RUN npm install -g babel-plugin-transform-runtime@6.15.0
RUN npm install -g babel-preset-react@6.16.0
RUN npm install -g babel-preset-stage-0@6.16.0
RUN npm install -g babel-register@6.16.3
COPY config/node_ctl.sh /root/node_ctl.sh

# nginx
RUN apt-get install -y nginx nginx-extras
COPY config/nginx-site.conf /etc/nginx/sites-available/default
COPY config/nginx.sh /root/nginx.sh

# init
COPY config/init.sh /root/init.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
