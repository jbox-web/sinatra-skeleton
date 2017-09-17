# Sinatra Skeleton

[![GitHub license](https://img.shields.io/github/license/jbox-web/sinatra-skeleton.svg)](https://github.com/jbox-web/sinatra-skeleton/blob/master/LICENSE)
[![Dependency Status](https://gemnasium.com/badges/github.com/jbox-web/sinatra-skeleton.svg)](https://gemnasium.com/github.com/jbox-web/sinatra-skeleton)

A skeleton for Sinatra application.

It comes with this gems :

* **sinatra** (of course)
* **puma** (for the webserver)
* **dotenv** (to get settings from env vars)
* **figaro** (to validate env vars presence)
* **settingslogic** (to store/retrieve settings)
* **foreman** (to have a start command and to export systemd config files)

For the deployment we use :

* **capistrano** (to do the deployment)
* **capistrano-rvm** (because we use RVM)
* **capistrano-bundler** (to install gems on deployment)
* **capistrano-foreman** (so we can start/restart the application remotely)
* **capistrano-template** (to install configuration files on deployment)


## Usage in development

```sh
nicolas@desktop: git clone https://github.com/jbox-web/sinatra-skeleton.git
nicolas@desktop: cd sinatra-skeleton
nicolas@desktop: bundle install
nicolas@desktop: bin/foreman start
```

You can customize environment variables by creating a `.env` file at the root of the project :

```sh
RACK_ENV=production
WEB_CONCURRENCY=1
PORT=5000
```


## Create a new app

To create a new application from this repository run the `rename.sh` script at the root :

```sh
nicolas@desktop: ./rename.sh MyProject my_project
```

The arguments are the new project name in **PascalCase** then the new project name in **snake_case**.

The first is to `sed` string in files, the second to rename `lib/sinatra_skeleton` directory.

The script will rename the string `SinatraSkeleton` to `MyProject` and will move `lib/sinatra_skeleton` directory to `lib/my_project`.

The rest is up to you! (reinitializing repository, etc...) (do a `git status` to see the changes)

## Deployment

### With Docker

You can build a Docker image and run it :

```sh
nicolas@desktop: make build
nicolas@desktop: make start
```

To get the container status :

```sh
nicolas@desktop: make status
```

To stop the container :

```sh
nicolas@desktop: make stop
```

### With Capistrano

Or you can deploy in the good old fashion :

1. Create a `sinatra-skeleton` user on a server and install your SSH public key

```sh
# As root
root: adduser --disabled-password --home /data/www/sinatra-skeleton sinatra-skeleton
root: su - sinatra-skeleton

# As sinatra-skeleton user
sinatra-skeleton: mkdir .ssh
sinatra-skeleton: vi .ssh/authorized_keys
```

2. Install RVM on the server as `sinatra-skeleton` user

```sh
# As sinatra-skeleton user
sinatra-skeleton: gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
sinatra-skeleton: \curl -sSL https://get.rvm.io | bash -s stable
```

3. Intall Ruby 2.4.2 and Bundler

```sh
# As sinatra-skeleton user
sinatra-skeleton: rvm install 2.4.2
sinatra-skeleton: gem install bundler
```

4. Create Capistrano config file

On your local computer :

* Rename `config/deploy/production.rb.dist` into `config/deploy/production.rb` and update it to make it point to your server.

* Deploy with Capistrano

```sh
nicolas@desktop: cap production deploy
```
