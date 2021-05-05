# Fetch base image
FROM ruby:3.0.1-slim-buster

# Be sure to run in noninteractive mode
# See: https://www.debian.org/releases/buster/amd64/ch05s03.fr.html#installer-args
ENV DEBIAN_FRONTEND noninteractive

# Disable initramfs update during packages installation
# See: https://manpages.debian.org/buster/initramfs-tools-core/initramfs-tools.7.en.html#KERNEL_HOOKS
ENV INITRD No

# Make bash commands more robust
# See: https://github.com/hadolint/hadolint/wiki/DL4006
# See: https://kvz.io/bash-best-practices.html
SHELL ["/bin/bash", "-o", "errexit", "-o", "pipefail", "-c"]

# Set timezone
ARG TIMEZONE=Europe/Paris

RUN \
  # Set timezone
  echo "${TIMEZONE}" > /etc/timezone && \
  rm -f /etc/localtime && ln -snf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata && \
  \
  # Fetch Debian updates
  apt-get update && \
  \
  # Upgrade the system first
  apt-get update && apt-get upgrade -y && \
  \
  # Install dependencies
  apt-get install -y build-essential libpq-dev libmariadb-dev && \
  \
  # Add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
  groupadd --gid 1000 runner && useradd --uid 1000 --gid 1000 --home-dir /home/runner --shell /bin/bash --create-home runner && \
  \
  # Create workdir
  mkdir /app && chown -R runner\: /app && \
  \
  # Cleanup image
  apt-get -y --purge autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  find /var/log/ -type f -delete

# Switch user
USER runner
WORKDIR /app

# Copy Gemfile
COPY Gemfile /app/
COPY Gemfile.lock /app/

# Declare some environment variables
ENV DOCKER=true \
    USER=runner \
    HOME=/home/runner \
    RACK_ENV=production

# Install gems
RUN bundle config set without development test
RUN bundle install --jobs 4 --retry 3

# Install application
COPY . /app
