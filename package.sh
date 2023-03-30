#!/bin/bash

SOURCE_DIR=~/code/gitwork/project1/app
DESTINATION_DIR=~/code/gitwork/site.name/content/project1

if [[ ! -d $DESTINATION_DIR ]] ; then
    mkdir -p $DESTINATION_DIR
fi

cp -r $SOURCE_DIR $DESTINATION_DIR