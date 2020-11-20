# Dockerfile.rails

FROM ruby:2.6.3
MAINTAINER 1smeha1@gmail.com
WORKDIR /test-cont
# Copy all the application's files into the /test-cont directory.
COPY . /test-cont
RUN bundle install
