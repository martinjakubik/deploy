#!/bin/bash
# sets up usage
USAGE="usage: $0 -i|--inputDir project_root_directory -s|--siteId siteId --siteNickname siteNickname -u|--userId userId --ip ipAddress -c|--incremental -d|--debug"

# sets up defaults
DEBUG=0
project_root_directory=~/project_root_directory
siteId=abcd
siteNickname=abcdhome
destinationDir=~/destinationDir
incremental=0

# parses and reads command line arguments
while [ $# -gt 0 ]
do
  case "$1" in
    (-i) project_root_directory="${2%\/}"; shift;;
    (--inputDir) project_root_directory="${2%\/}"; shift;;
    (-s) siteId="$2"; shift;;
    (--siteId) siteId="$2"; shift;;
    (--siteNickname) siteNickname="$2"; shift;;
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

STAGING_DIR=/var/x-www-staging
DESTINATION_DIR="${STAGING_DIR}"/${siteId}
DESTINATION_DIR_WITH_USER_AND_IP=${userId}@${ipAddress}:"${DESTINATION_DIR}"
site_distribution_dir="${project_root_directory%/}"/site

echo --------------------------------------------------------------------------------
echo script: $0
echo you entered values
echo   "From project root dir       : ${project_root_directory}"
echo   "and site distribution dir   : ${site_distribution_dir}"
echo   "To                          : ${DESTINATION_DIR_WITH_USER_AND_IP}"
echo   "site ID                     : ${siteId}"
echo   "site nickname               : ${siteNickname}"
echo   "user                        : ${userId}"
echo   "IP address                  : ${ipAddress}"
echo --------------------------------------------------------------------------------
echo

existing_directory_array=()

ensure_directory_exists_for_file() {
  filename_to_check="$1"
  remoteTargetDirectory="$DESTINATION_DIR"/$(dirname "$filename_to_check")
  if printf '%s\0' "${existing_directory_array[@]}" | grep -Fxqz -- "${remoteTargetDirectory}" ; then
    is_directory_found_on_remote=1
  else
    is_directory_found_on_remote=0
  fi
  if [[ ! $is_directory_found_on_remote -eq 1 ]]; then
    echo creating remote directory "${remoteTargetDirectory}"
    if [[ $DEBUG -eq 0 ]] ; then
      ssh ${userId}@${ipAddress} "if [[ ! -d $remoteTargetDirectory ]] ; then mkdir -p $remoteTargetDirectory ; fi"
    elif [[ $DEBUG -eq 1 ]] ; then
      echo ssh ${userId}@${ipAddress} "if [[ ! -d $remoteTargetDirectory ]] ; then mkdir -p $remoteTargetDirectory ; fi"
    fi
    existing_directory_array+=("$remoteTargetDirectory")
  fi
}

upload_listed_files() {
  echo ---
  echo "uploading files listed in ${project_root_directory}/upload_files.txt"
  upload_count=0
  upload_count_in_set=0
  if [[ -e "${project_root_directory}"/upload_files.txt ]] ; then
    file_array=()

    while IFS= read -r line; do
      file_array+=($line)
    done < "${project_root_directory}"/upload_files.txt

    for filename in "${file_array[@]}" ; do
      requested_filename="${site_distribution_dir}"/"$filename"
      if [[ -e "$requested_filename" ]] ; then
        ensure_directory_exists_for_file "$filename"
        if [[ $DEBUG -eq 0 ]] ; then
          scp "$requested_filename" "${DESTINATION_DIR_WITH_USER_AND_IP}"/"$filename"
        else
          echo uploading "$requested_filename" to "${DESTINATION_DIR_WITH_USER_AND_IP}"/"$filename"
        fi
        upload_count=$(( upload_count+1 ))
        upload_count_in_set=$(( upload_count_in_set+1 ))
        echo $upload_count files uploaded $upload_count_in_set files uploaded in set
        if [[ $upload_count_in_set -gt 7 ]] ; then
          echo sleeping 30s
          sleep 30s
          upload_count_in_set=0
        fi
      else
        echo the file: "$requested_filename" does not exist
      fi
    done
  else
    echo the list of files "${project_root_directory}"/upload_files.txt does not exist
  fi
  echo ---
}

if [[ $DEBUG -eq 0 ]] ; then
    ./prepare.sh --inputDir "${project_root_directory}" -s ${siteId} --siteNickname ${siteNickname}

    # checks if a plain file already exists with the name of the destination directory
    ssh ${userId}@${ipAddress} "if [[ -f ${DESTINATION_DIR} ]] ; then exit 1 ; fi"
    check_destination_directory_exit_code=$?
    if [[ $check_destination_directory_exit_code -eq 1 ]] ; then
      echo "a plain file called ${DESTINATION_DIR} already exists; stopping."
      exit 1
    fi

    # uploads content to the server directory
    if [[ -d "${project_root_directory}"/server ]] ; then
      find "${project_root_directory}"/server -name .DS_Store -delete
      ensure_directory_exists_for_file server/dummy.txt
      scp -r "${project_root_directory}"/server "${DESTINATION_DIR_WITH_USER_AND_IP}"/
    fi

    # uploads content to the library directory
    if [[ -d "${site_distribution_dir}"/lib ]] ; then
      find "${site_distribution_dir}"/lib -name .DS_Store -delete
      scp -r "${site_distribution_dir}"/lib "${DESTINATION_DIR_WITH_USER_AND_IP}"/
    fi

    # uploads the project's npm package description
    scp "${project_root_directory}"/package.json "${DESTINATION_DIR_WITH_USER_AND_IP}"/

    if [[ ${incremental} -eq 1 ]] ; then
      upload_listed_files
    fi

    # uploads the site's metafiles
    scp site-canonical-files ${siteId}-custom-files ${siteId}-apps "${DESTINATION_DIR_WITH_USER_AND_IP}"/

    # uploads the canonical files
    scp "${site_distribution_dir}"/robots.txt "${site_distribution_dir}"/index.html "${site_distribution_dir}"/index.test.html "${site_distribution_dir}"/screen.css "${site_distribution_dir}"/app.js "${site_distribution_dir}"/title.png "${site_distribution_dir}"/logo.png "${site_distribution_dir}"/background.png "${site_distribution_dir}"/background-tile.png "${site_distribution_dir}"/settings.png "${DESTINATION_DIR_WITH_USER_AND_IP}"/

    if [[ ${incremental} -eq 0 ]] ; then
      ssh ${userId}@${ipAddress} "touch ${DESTINATION_DIR}/all_files_uploaded"
    fi
else
    ./prepare.sh --inputDir "${project_root_directory}" -s ${siteId} --siteNickname ${siteNickname} --debug

    # debugs upload of the server directory
    if [[ -d "${project_root_directory}"/server ]] ; then
      find "${project_root_directory}"/server -name .DS_Store
      ensure_directory_exists_for_file server/dummy.txt
      echo scp -r "${project_root_directory}"/server "${DESTINATION_DIR_WITH_USER_AND_IP}"/
    fi

    # debugs upload of the library directory
    if [[ -d "${site_distribution_dir}"/lib ]] ; then
      find "${site_distribution_dir}"/lib -name .DS_Store
      echo scp -r "${site_distribution_dir}"/lib "${DESTINATION_DIR_WITH_USER_AND_IP}"/
    fi

    # debugs upload of the project's npm package description
    echo scp "${project_root_directory}"/package.json "${DESTINATION_DIR_WITH_USER_AND_IP}"/

    if [[ ${incremental} -eq 1 ]] ; then
      upload_listed_files
    fi

    # debugs upload of the canonical files
    echo scp "${site_distribution_dir}"/robots.txt "${site_distribution_dir}"/index.html "${site_distribution_dir}"/index.test.html $"{site_distribution_dir}"/screen.css "${site_distribution_dir}"/app.js "${site_distribution_dir}"/title.png "${site_distribution_dir}"/logo.png "${site_distribution_dir}"/background.png "${site_distribution_dir}"/background-tile.png "${site_distribution_dir}"/settings.png "${DESTINATION_DIR_WITH_USER_AND_IP}"/
fi
