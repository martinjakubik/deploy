#!/bin/bash
# sets up usage
USAGE="usage: $0 -i --inputDir inputDir -s siteId --siteShortName siteShortName -u --userId userId --ip ipAddress --debug"

# set up defaults
DEBUG=0
inputDir=~/inputDir
siteId=abcd
siteShortName=abcdhome
destinationDir=~/destinationDir

# parses and reads command line arguments
while [ $# -gt 0 ]
do
  case "$1" in
    (-i) inputDir="$2"; shift;;
    (--inputDir) inputDir="$2"; shift;;
    (-s) siteId="$2"; shift;;
    (--siteShortName) siteShortName="$2"; shift;;
    (-u) userId="$2"; shift;;
    (--userId) userId="$2"; shift;;
    (--ip) ipAddress="$2"; shift;;
    (-d) DEBUG=1;;
    (--debug) DEBUG=1;;
    (-*) echo >&2 ${USAGE}
    exit 1;;
  esac
  shift
done

DESTINATION_DIR=${userId}@${ipAddress}:/home/${userId}/${siteId}staticsiteupload
HTROOT_SOURCE_DIR=${inputDir}/${siteId}staticsite/htdocs

echo you entered values
echo   "From inputDir : $inputDir"
echo   "and htrootdir : $HTROOT_SOURCE_DIR"
echo   "To            : $DESTINATION_DIR"
echo   "site ID       : $siteId"
echo   "site nick     : $siteShortName"
echo   "user          : $userId"
echo   "IP address    : $ipAddress"


if [[ $DEBUG -eq 0 ]] ; then
    ./prepare.sh --inputDir ${inputDir} -s ${siteId} --siteShortName ${siteShortName}

    find ${inputDir}/server -name .DS_Store -delete
    scp -r ${inputDir}/server $DESTINATION_DIR
    scp ${inputDir}/package.json $DESTINATION_DIR

    find ${HTROOT_SOURCE_DIR}/content -name .DS_Store -delete
    scp -r ${HTROOT_SOURCE_DIR}/content $DESTINATION_DIR

    scp ${HTROOT_SOURCE_DIR}/index.html ${HTROOT_SOURCE_DIR}/screen.css ${DESTINATION_DIR}

    scp ${HTROOT_SOURCE_DIR}/logo.png ${HTROOT_SOURCE_DIR}/background.png ${HTROOT_SOURCE_DIR}/settings.png ${DESTINATION_DIR}
else
    ./prepare.sh --inputDir ${inputDir} -s ${siteId} --siteShortName ${siteShortName} --debug

    echo scp -r ${inputDir}/server $DESTINATION_DIR
    echo scp ${inputDir}/package.json $DESTINATION_DIR

    echo scp -r ${HTROOT_SOURCE_DIR}/content $DESTINATION_DIR

    echo scp ${HTROOT_SOURCE_DIR}/index.html ${HTROOT_SOURCE_DIR}/screen.css ${DESTINATION_DIR}

    echo scp ${HTROOT_SOURCE_DIR}/logo.png ${HTROOT_SOURCE_DIR}/background.png ${HTROOT_SOURCE_DIR}/settings.png ${DESTINATION_DIR}
fi