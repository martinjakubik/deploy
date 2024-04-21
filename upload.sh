#!/bin/bash
# sets up usage
USAGE="usage: $0 -i --inputDir inputDir -s siteId --siteShortName siteShortName -u --userId userId --ip ipAddress -c --incremental -d --debug"

# set up defaults
DEBUG=0
inputDir=~/inputDir
siteId=abcd
siteShortName=abcdhome
destinationDir=~/destinationDir
incremental=0

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
    (-c) incremental=1;;
    (--incremental) incremental=1;;
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

upload_listed_files() {
  echo "uploading files listed in upload_files.txt"
  if [[ -e upload_files.txt ]] ; then
    file_array=()
    while IFS= read -r line; do
      file_array+=($line)
    done < upload_files.txt
    for filename in "${file_array[@]}" ; do
      requested_filename=${HTROOT_SOURCE_DIR}/content/$filename
      if [[ -e $requested_filename ]] ; then
        if [[ $DEBUG -eq 0 ]] ; then
          scp $requested_filename $DESTINATION_DIR
        else
          echo uploading $requested_filename
        fi
      else
        echo the file: $requested_filename does not exist
      fi
    done
  else
    echo the list of files upload_files.txt does not exist
  fi
}

if [[ $DEBUG -eq 0 ]] ; then
    ./prepare.sh --inputDir ${inputDir} -s ${siteId} --siteShortName ${siteShortName}

    find ${inputDir}/server -name .DS_Store -delete
    scp -r ${inputDir}/server $DESTINATION_DIR
    scp ${inputDir}/package.json $DESTINATION_DIR

    if [[ ${incremental} -eq 0 ]] ; then
      find ${HTROOT_SOURCE_DIR}/content -name .DS_Store -delete
      echo scp -r ${HTROOT_SOURCE_DIR}/content $DESTINATION_DIR
    elif [[ ${incremental} -eq 1 ]] ; then
      upload_listed_files
    fi

    scp ${HTROOT_SOURCE_DIR}/index.html ${HTROOT_SOURCE_DIR}/screen.css ${DESTINATION_DIR}

    scp ${HTROOT_SOURCE_DIR}/logo.png ${HTROOT_SOURCE_DIR}/background.png ${HTROOT_SOURCE_DIR}/settings.png ${DESTINATION_DIR}
else
    ./prepare.sh --inputDir ${inputDir} -s ${siteId} --siteShortName ${siteShortName} --debug

    echo scp -r ${inputDir}/server $DESTINATION_DIR
    echo scp ${inputDir}/package.json $DESTINATION_DIR

    if [[ ${incremental} -eq 0 ]] ; then
      echo scp -r ${HTROOT_SOURCE_DIR}/content $DESTINATION_DIR
    elif [[ ${incremental} -eq 1 ]] ; then
      upload_listed_files
    fi

    echo scp ${HTROOT_SOURCE_DIR}/index.html ${HTROOT_SOURCE_DIR}/screen.css ${DESTINATION_DIR}

    echo scp ${HTROOT_SOURCE_DIR}/logo.png ${HTROOT_SOURCE_DIR}/background.png ${HTROOT_SOURCE_DIR}/settings.png ${DESTINATION_DIR}
fi