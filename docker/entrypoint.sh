#!/bin/bash
set -e

cd /usr/src/app
bin/puma -C config/puma.rb
