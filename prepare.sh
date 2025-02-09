#!/bin/bash

# sets up usage
USAGE="usage: $0 -i --inputDir inputDir -s siteId --siteShortName siteShortName -d --debug"

# set up defaults
DEBUG=0
inputDir=~/inputDir
siteId=abcd

# parses and reads command line arguments
while [ $# -gt 0 ]
do
  case "$1" in
    (-i) inputDir="$2"; shift;;
    (--inputDir) inputDir="$2"; shift;;
    (-s) siteId="$2"; shift;;
    (--siteShortName) siteShortName="$2"; shift;;
    (-d) DEBUG=1;;
    (--debug) DEBUG=1;;
    (-*) echo >&2 ${USAGE}
    exit 1;;
  esac
  shift
done

HTROOT_SOURCE_DIR=${inputDir}/${siteId}staticsite/htdocs

echo you entered values
echo   "From inputDir : $inputDir"
echo   "site nick     : $siteShortName"
echo   "site ID       : $siteId"

if [[ $DEBUG -eq 0 ]] ; then
    cp ${inputDir}/stitlestaticsite/htdocs/palette.mjs ${inputDir}/stitlestaticsite/htdocs/content/fractals/app/
    cp ${inputDir}/resources/${siteShortName}-title.png ${HTROOT_SOURCE_DIR}/title.png
    cp ${inputDir}/resources/${siteShortName}-logo.png ${HTROOT_SOURCE_DIR}/logo.png
    cp ${inputDir}/resources/${siteShortName}-background.png ${HTROOT_SOURCE_DIR}/background.png
    cp ${inputDir}/resources/${siteShortName}-settings.png ${HTROOT_SOURCE_DIR}/settings.png
    cp ${inputDir}/resources/${siteShortName}-volume-on.png ${HTROOT_SOURCE_DIR}/volume-on.png
    cp ${inputDir}/resources/${siteShortName}-volume-off.png ${HTROOT_SOURCE_DIR}/volume-off.png
    cp ${inputDir}/resources/chirp.mp3 ${HTROOT_SOURCE_DIR}/chirp.mp3
else
    echo cp ${inputDir}/stitlestaticsite/htdocs/palette.mjs ${inputDir}/stitlestaticsite/htdocs/content/fractals/app/
    echo cp ${inputDir}/resources/${siteShortName}-title.png ${HTROOT_SOURCE_DIR}/title.png
    echo cp ${inputDir}/resources/${siteShortName}-logo.png ${HTROOT_SOURCE_DIR}/logo.png
    echo cp ${inputDir}/resources/${siteShortName}-background.png ${HTROOT_SOURCE_DIR}/background.png
    echo cp ${inputDir}/resources/${siteShortName}-settings.png ${HTROOT_SOURCE_DIR}/settings.png
    echo cp ${inputDir}/resources/${siteShortName}-volume-on.png ${HTROOT_SOURCE_DIR}/volume-on.png
    echo cp ${inputDir}/resources/${siteShortName}-volume-off.png ${HTROOT_SOURCE_DIR}/volume-off.png
    echo cp ${inputDir}/resources/chirp.mp3 ${HTROOT_SOURCE_DIR}/chirp.mp3
fi