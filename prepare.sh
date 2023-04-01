#!/bin/bash

ROOT_SOURCE_DIR=~/code/gitwork/site.name/
HTROOT_SOURCE_DIR=~/code/gitwork/site.name/abcdstaticsite/htdocs
SOURCE_DIR=~/code/gitwork/site.name/content
DESTINATION_DIR=martin@192.46.222.142:/home/martin/abcdstaticsiteupload

cp $ROOT_SOURCE_DIR/resources/abcd-logo.png $ROOT_SOURCE_DIR/logo.png
cp $ROOT_SOURCE_DIR/resources/abcd-volume-on.png $ROOT_SOURCE_DIR/volume-on.png
cp $ROOT_SOURCE_DIR/resources/abcd-volume-off.png $ROOT_SOURCE_DIR/volume-off.png
cp $ROOT_SOURCE_DIR/resources/sound.mp3 $ROOT_SOURCE_DIR/sound.mp3