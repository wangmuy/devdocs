FROM ruby:2.4.1
MAINTAINER Conor Heine <conor.heine@gmail.com>

COPY sources.list.ustc /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install git nodejs sudo

COPY . /devdocs
RUN gem sources --remove https://rubygems.org/ --add https://gems.ruby-china.org/
RUN gem install bundler

VOLUME /scripts

WORKDIR /devdocs

RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.org
RUN bundle install --system

# chinese env
ENV LANG C.UTF-8

EXPOSE 9292
COPY entryScripts/entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]

