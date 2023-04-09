#!/bin/bash
# sets up usage
USAGE="usage: $0 -i --inputDir inputDir -o --destinationDir destinationDir -d --debug"

# set up defaults
DEBUG=0
inputDir=~/inputDir
destinationDir=~/destinationDir

# parses and reads command line arguments
while [ $# -gt 0 ]
do
  case "$1" in
    (-i) inputDir="$2"; shift;;
    (--inputDir) inputDir="$2"; shift;;
    (-o) destinationDir="$2"; shift;;
    (--destinationDir) destinationDir="$2"; shift;;
    (-d) DEBUG=1;;
    (--debug) DEBUG=1;;
    (-*) echo >&2 ${USAGE}
    exit 1;;
  esac
  shift
done

echo you entered values
echo   "From inputDir : $inputDir"
echo   "To            : $destinationDir"

if [[ ! -d $destinationDir ]] ; then
    mkdir -p $destinationDir
fi

if [[ $DEBUG -eq 0 ]] ; then
    # uploads the files
    if [[ ! -d $destinationDir ]] ; then
        mkdir -p $destinationDir
    fi
    cp -r $inputDir $destinationDir
else
    # DEBUG mode: prints out commands without executing
    if [[ ! -d $destinationDir ]] ; then
        echo mkdir -p $destinationDir
    fi
    echo cp -r $inputDir $destinationDir
fi