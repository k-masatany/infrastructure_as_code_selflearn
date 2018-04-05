##
# phusion/passenger-docker
# https://github.com/phusion/passenger-docker

##
# Getting started

# Ruby images
FROM phusion/passenger-ruby25:latest

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

##
# Nginx

# Using Nginx and Passenger
RUN rm -f /etc/service/nginx/down

# Using Nginx and Passenger
RUN rm /etc/nginx/sites-enabled/default
ADD nginx/webapp.conf /etc/nginx/sites-enabled/webapp.conf

# Configuring Nginx
ADD nginx/secret_key.conf /etc/nginx/main.d/secret_key.conf
ADD nginx/gzip_max.conf /etc/nginx/conf.d/gzip_max.conf

##
# Rails application

# Set correct environment variables.
# ENV RAILS_ENV development
ENV RAILS_ENV production

# Your application should be placed inside /home/app.
COPY --chown=app:app rails-app /home/app/webapp

# bundlerのインストール
# 実行しなかった場合、Railsアプリにアクセスした時に以下のエラーが発生する
# cannot load such file -- bundler/dep_proxy (LoadError)
RUN gem install bundler

# tzdataのインストール
# 実行しなかった場合、Railsアプリにアクセスした時に以下のエラーが発生する
# tzinfo-data is not present.
# Please add gem 'tzinfo-data' to your Gemfile
# and run bundle install (TZInfo::DataSourceNotFound)
RUN apt-get update && apt-get install -y \
    tzdata

# bundle install
WORKDIR /home/app/webapp
RUN bundle install

# assets:precompile
RUN bundle exec rake assets:precompile

EXPOSE 80

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*