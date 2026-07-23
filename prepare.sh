#!/bin/bash

# sets up usage
USAGE="usage: $0 -i|--inputDir project_root_directory s|--siteId siteId --siteShortName siteShortName -d|--debug"

# sets up defaults
DEBUG=0
project_root_directory=~/project_root_directory
siteId=abcd
siteShortName=abcdhome

# parses and reads command line arguments
while [ $# -gt 0 ]
do
  case "$1" in
    (-i) project_root_directory="${2%\/}"; shift;;
    (--inputDir) project_root_directory="${2%\/}"; shift;;
    (-s) siteId="$2"; shift;;
    (--siteId) siteId="$2"; shift;;
    (--siteShortName) siteShortName="$2"; shift;;
    (-d) DEBUG=1;;
    (--debug) DEBUG=1;;
    (-*) echo >&2 ${USAGE}
    exit 1;;
  esac
  shift
done

HTROOT_SOURCE_DIR=${project_root_directory%\/}/site

echo --------------------------------------------------------------------------------
echo script: $0
echo you entered values
echo   "From project root dir : ${project_root_directory}"
echo   "site nick             : ${siteShortName}"
echo   "site ID               : ${siteId}"
echo --------------------------------------------------------------------------------
echo

if [[ $DEBUG -eq 0 ]] ; then
    cp ${project_root_directory}/resources/${siteShortName}-title.png ${HTROOT_SOURCE_DIR}/title.png
    cp ${project_root_directory}/resources/${siteShortName}-logo.png ${HTROOT_SOURCE_DIR}/logo.png
    cp ${project_root_directory}/resources/${siteShortName}-background.png ${HTROOT_SOURCE_DIR}/background.png
    cp ${project_root_directory}/resources/${siteShortName}-background-tile.png ${HTROOT_SOURCE_DIR}/background-tile.png
    cp ${project_root_directory}/resources/${siteShortName}-settings.png ${HTROOT_SOURCE_DIR}/settings.png
    cp ${project_root_directory}/resources/${siteShortName}-volume-on.png ${HTROOT_SOURCE_DIR}/volume-on.png
    cp ${project_root_directory}/resources/${siteShortName}-volume-off.png ${HTROOT_SOURCE_DIR}/volume-off.png
else
    echo cp ${project_root_directory}/resources/${siteShortName}-title.png ${HTROOT_SOURCE_DIR}/title.png
    echo cp ${project_root_directory}/resources/${siteShortName}-logo.png ${HTROOT_SOURCE_DIR}/logo.png
    echo cp ${project_root_directory}/resources/${siteShortName}-background.png ${HTROOT_SOURCE_DIR}/background.png
    echo cp ${project_root_directory}/resources/${siteShortName}-background-tile.png ${HTROOT_SOURCE_DIR}/background-tile.png
    echo cp ${project_root_directory}/resources/${siteShortName}-settings.png ${HTROOT_SOURCE_DIR}/settings.png
    echo cp ${project_root_directory}/resources/${siteShortName}-volume-on.png ${HTROOT_SOURCE_DIR}/volume-on.png
    echo cp ${project_root_directory}/resources/${siteShortName}-volume-off.png ${HTROOT_SOURCE_DIR}/volume-off.png
fi