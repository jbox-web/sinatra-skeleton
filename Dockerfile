FROM ruby:2.7.1-slim-buster
MAINTAINER nicoladmin@free.fr

# Declare some environment variables
ENV DOCKER=true \
    RACK_ENV=production

# Install dependencies
RUN apt-get update && apt-get -y upgrade && apt-get -y install build-essential

# Create application directory
RUN /bin/sh -c "mkdir -p /usr/src/app"
WORKDIR /usr/src/app

# Install gems
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

# Install application
COPY . /usr/src/app

# Copy entrypoint script. This is a init script but
# just for apt-cacher-ng as there is not init system
# inside the container
COPY docker/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Configure the container
EXPOSE 5000/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
