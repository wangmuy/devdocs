#!/bin/sh
cd /devdocs && git pull origin master && $BUNDLE_PATH/bin/thor docs:download --installed
