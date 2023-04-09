#!/bin/bash

# sets up usage
USAGE="usage: $0 -i --inputDir inputDir --siteShortName siteShortName -d --debug"

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
    (--siteShortName) siteShortName="$2"; shift;;
    (-d) DEBUG=1;;
    (--debug) DEBUG=1;;
    (-*) echo >&2 ${USAGE}
    exit 1;;
  esac
  shift
done

echo you entered values
echo   "From inputDir : $inputDir"
echo   "for site nick : $siteShortName"

if [[ $DEBUG -eq 0 ]] ; then
    cp ${inputDir}/resources/${siteShortName}-logo.png ${inputDir}/logo.png
    cp ${inputDir}/resources/${siteShortName}-background.png ${inputDir}/background.png
    cp ${inputDir}/resources/${siteShortName}-settings.png ${inputDir}/settings.png
    cp ${inputDir}/resources/${siteShortName}-volume-on.png ${inputDir}/volume-on.png
    cp ${inputDir}/resources/${siteShortName}-volume-off.png ${inputDir}/volume-off.png
    cp ${inputDir}/resources/chirp.mp3 ${inputDir}/chirp.mp3
else
    echo cp ${inputDir}/resources/${siteShortName}-logo.png ${inputDir}/logo.png
    echo cp ${inputDir}/resources/${siteShortName}-background.png ${inputDir}/background.png
    echo cp ${inputDir}/resources/${siteShortName}-settings.png ${inputDir}/settings.png
    echo cp ${inputDir}/resources/${siteShortName}-volume-on.png ${inputDir}/volume-on.png
    echo cp ${inputDir}/resources/${siteShortName}-volume-off.png ${inputDir}/volume-off.png
    echo cp ${inputDir}/resources/chirp.mp3 ${inputDir}/chirp.mp3
fi