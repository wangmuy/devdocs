
FROM ruby:2.4.1
MAINTAINER Conor Heine <conor.heine@gmail.com>

RUN apt-get update
RUN apt-get -y install git nodejs
#COPY . /devdocs
RUN gem install bundler

VOLUME /scripts
VOLUME /devdocs

WORKDIR /devdocs

RUN bundle install
#RUN bundle install --system
#RUN thor docs:download --all

# chinese env
ENV LANG C.UTF-8

EXPOSE 9292
COPY entryScripts/entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
#CMD rackup -o 0.0.0.0

