FROM ruby:2.4.2-onbuild
MAINTAINER nicoladmin@free.fr

# Declare some environment variables
ENV DOCKER=true \
    RACK_ENV=production

# Copy entrypoint script. This is a init script but
# just for apt-cacher-ng as there is not init system
# inside the container
COPY docker/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Configure the container
EXPOSE 5000/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
