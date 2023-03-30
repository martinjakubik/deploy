#!/bin/bash

ROOT_SOURCE_DIR=~/code/gitwork/site.name/
HTROOT_SOURCE_DIR=~/code/gitwork/site.name/abcstaticsite/htdocs
SOURCE_DIR=~/code/gitwork/site.name/content
DESTINATION_DIR=user1@ipv4:/home/user1/abcstaticsiteupload

./prepare.sh

scp -r $SOURCE_DIR/project1 $DESTINATION_DIR/project1
scp -r $SOURCE_DIR/project2 $DESTINATION_DIR

scp $HTROOT_SOURCE_DIR/index.html $HTROOT_SOURCE_DIR/screen.css $DESTINATION_DIR

scp $ROOT_SOURCE_DIR/logo.png $ROOT_SOURCE_DIR/android-chrome-512x512.png $ROOT_SOURCE_DIR/android-chrome-192x192.png $ROOT_SOURCE_DIR/apple-touch-icon.png $ROOT_SOURCE_DIR/favicon-16x16.png $ROOT_SOURCE_DIR/favicon-32x32.png $ROOT_SOURCE_DIR/favicon.ico $DESTINATION_DIR