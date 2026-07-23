#!/bin/bash

# sets up usage
USAGE="usage: $0 -i|--inputDir project_root_directory s|--siteId siteId --siteNickname siteNickname -d|--debug"

# sets up defaults
DEBUG=0
project_root_directory=~/project_root_directory
siteId=abcd
siteNickname=abcdhome

# parses and reads command line arguments
while [ $# -gt 0 ]
do
  case "$1" in
    (-i) project_root_directory="${2%\/}"; shift;;
    (--inputDir) project_root_directory="${2%\/}"; shift;;
    (-s) siteId="$2"; shift;;
    (--siteId) siteId="$2"; shift;;
    (--siteNickname) siteNickname="$2"; shift;;
    (-d) DEBUG=1;;
    (--debug) DEBUG=1;;
    (-*) echo >&2 ${USAGE}
    exit 1;;
  esac
  shift
done

site_source_directory=${project_root_directory%\/}/site

echo --------------------------------------------------------------------------------
echo script: $0
echo you entered values
echo   "From project root dir : ${project_root_directory}"
echo   "site nick             : ${siteNickname}"
echo   "site ID               : ${siteId}"
echo --------------------------------------------------------------------------------
echo

if [[ $DEBUG -eq 0 ]] ; then
    cp ${project_root_directory}/resources/${siteNickname}-title.png ${site_source_directory}/title.png
    cp ${project_root_directory}/resources/${siteNickname}-logo.png ${site_source_directory}/logo.png
    cp ${project_root_directory}/resources/${siteNickname}-background.png ${site_source_directory}/background.png
    cp ${project_root_directory}/resources/${siteNickname}-background-tile.png ${site_source_directory}/background-tile.png
    cp ${project_root_directory}/resources/${siteNickname}-settings.png ${site_source_directory}/settings.png
    cp ${project_root_directory}/resources/${siteNickname}-volume-on.png ${site_source_directory}/volume-on.png
    cp ${project_root_directory}/resources/${siteNickname}-volume-off.png ${site_source_directory}/volume-off.png
else
    echo cp ${project_root_directory}/resources/${siteNickname}-title.png ${site_source_directory}/title.png
    echo cp ${project_root_directory}/resources/${siteNickname}-logo.png ${site_source_directory}/logo.png
    echo cp ${project_root_directory}/resources/${siteNickname}-background.png ${site_source_directory}/background.png
    echo cp ${project_root_directory}/resources/${siteNickname}-background-tile.png ${site_source_directory}/background-tile.png
    echo cp ${project_root_directory}/resources/${siteNickname}-settings.png ${site_source_directory}/settings.png
    echo cp ${project_root_directory}/resources/${siteNickname}-volume-on.png ${site_source_directory}/volume-on.png
    echo cp ${project_root_directory}/resources/${siteNickname}-volume-off.png ${site_source_directory}/volume-off.png
fi