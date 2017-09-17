#!/bin/bash
set -e

cd /usr/src/app
sbin/puma -C config/puma.rb
