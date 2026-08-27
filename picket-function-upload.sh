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

argument_value_incremental=""
if [[ $incremental -eq 1 ]] ; then
    argument_value_incremental="--incremental"
fi

argument_value_debug=""
if [[ $DEBUG -eq 1 ]] ; then
    argument_value_debug="--debug"
fi

STAGING_DIR=/var/x-www-staging
DESTINATION_DIR="${STAGING_DIR}"/${siteId}
if [[ $(picket-function-is-ipv6 --ip $ipAddress  $argument_value_incremental $argument_value_debug) -eq 1 ]] ; then
    DESTINATION_DIR_WITH_USER_AND_IP_ROOT=${userId}@\[${ipAddress}\]:"${DESTINATION_DIR}"
else
    DESTINATION_DIR_WITH_USER_AND_IP_ROOT=${userId}@${ipAddress}:"${DESTINATION_DIR}"
fi
DESTINATION_DIR_WITH_USER_AND_IP_SITE="${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/site
site_distribution_dir="${project_root_directory%/}"/site

does_canonical_source_code_file_list_exist=0
site_canonical_source_code_file_list=site-canonical-source-code-files
if [[ -f "${site_canonical_source_code_file_list}" ]] ; then
    does_canonical_source_code_file_list_exist=1
elif [[ -f /etc/picket/site-canonical-source-code-files ]] ; then
    does_canonical_source_code_file_list_exist=1
    site_canonical_source_code_file_list=/etc/picket/site-canonical-source-code-files
fi

does_canonical_binary_file_list_exist=0
site_canonical_binary_file_list=site-canonical-binary-files
if [[ -f "${site_canonical_binary_file_list}" ]] ; then
    does_canonical_binary_file_list_exist=1
elif [[ -f /etc/picket/site-canonical-binary-files ]] ; then
    does_canonical_binary_file_list_exist=1
    site_canonical_binary_file_list=/etc/picket/site-canonical-binary-files
fi

echo --------------------------------------------------------------------------------
echo script: $0
echo you entered values
echo   "From project root dir       : ${project_root_directory}"
echo   "and site distribution dir   : ${site_distribution_dir}"
echo   "To                          : ${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"
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
            if [[ $(picket-function-is-ipv6 --ip $ipAddress $argument_value_incremental $argument_value_debug) -eq 1 ]] ; then
                ssh ${userId}@${ipAddress} "if [[ ! -d $remoteTargetDirectory ]] ; then mkdir -p $remoteTargetDirectory ; fi"
            else
                ssh ${userId}@${ipAddress} "if [[ ! -d $remoteTargetDirectory ]] ; then mkdir -p $remoteTargetDirectory ; fi"
            fi
        elif [[ $DEBUG -eq 1 ]] ; then
            if [[ $(picket-function-is-ipv6 --ip $ipAddress $argument_value_incremental $argument_value_debug) -eq 1 ]] ; then
                echo ssh ${userId}@${ipAddress} "if [[ ! -d $remoteTargetDirectory ]] ; then mkdir -p $remoteTargetDirectory ; fi"
            else
                echo ssh ${userId}@${ipAddress} "if [[ ! -d $remoteTargetDirectory ]] ; then mkdir -p $remoteTargetDirectory ; fi"
            fi
        fi
        existing_directory_array+=("$remoteTargetDirectory")
    fi
}

upload_listed_site_files() {
    max_upload_count_before_throttle=4
    throttle_sleep_time_between_uploads=45s
    file_listing_files_to_upload="$1"
    echo
    echo "uploading files listed in $file_listing_files_to_upload"
    upload_count=0
    upload_count_in_set=0
    if [[ -e "$file_listing_files_to_upload" ]] ; then
        file_array=()

        while IFS= read -r line; do
            file_array+=($line)
        done < "$file_listing_files_to_upload"

        for filename in "${file_array[@]}" ; do
            requested_filename="${site_distribution_dir}"/"$filename"
            if [[ -e "$requested_filename" ]] ; then
                ensure_directory_exists_for_file site/"$filename"
                if [[ $DEBUG -eq 0 ]] ; then
                    scp "$requested_filename" "${DESTINATION_DIR_WITH_USER_AND_IP_SITE}"/"$filename"
                else
                    echo uploading "$requested_filename" to "${DESTINATION_DIR_WITH_USER_AND_IP_SITE}"/"$filename"
                fi
                upload_count=$(( upload_count+1 ))
                upload_count_in_set=$(( upload_count_in_set+1 ))
                echo $upload_count files uploaded $upload_count_in_set files uploaded in set
                if [[ $upload_count_in_set -gt $max_upload_count_before_throttle ]] ; then
                    echo sleeping $throttle_sleep_time_between_uploads
                    sleep $throttle_sleep_time_between_uploads
                    upload_count_in_set=0
                fi
            else
                echo the file: "$requested_filename" does not exist
            fi
        done
    else
        echo "the list of files $file_listing_files_to_upload does not exist"
    fi
    echo ... done
    echo
}

if [[ $DEBUG -eq 0 ]] ; then
    picket-function-prepare --inputDir "${project_root_directory}" -s ${siteId} --siteNickname ${siteNickname} $argument_value_incremental $argument_value_debug

    # checks if a plain file already exists with the name of the destination directory
    if [[ $(picket-function-is-ipv6 --ip $ipAddress  $argument_value_incremental $argument_value_debug) -eq 1 ]] ; then
        ssh ${userId}@${ipAddress} "if [[ -f ${DESTINATION_DIR} ]] ; then exit 1 ; fi"
    else
        ssh ${userId}@${ipAddress} "if [[ -f ${DESTINATION_DIR} ]] ; then exit 1 ; fi"
    fi
    check_destination_directory_exit_code=$?
    if [[ $check_destination_directory_exit_code -eq 1 ]] ; then
        echo "a plain file called ${DESTINATION_DIR} already exists; stopping."
        exit 1
    fi

    # uploads content to the server directory
    if [[ -d "${project_root_directory}"/server ]] ; then
        find "${project_root_directory}"/server -name .DS_Store -delete
        ensure_directory_exists_for_file server/dummy.txt
        echo
        echo "uploading server files"
        scp -r "${project_root_directory}"/server "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/
        echo ... done
        echo
    fi

    # uploads content to the library directory
    if [[ -d "${site_distribution_dir}"/lib ]] ; then
        find "${site_distribution_dir}"/lib -name .DS_Store -delete
        echo
        echo "uploading site library files"
        scp -r "${site_distribution_dir}"/lib "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/
        echo ... done
        echo
    fi

    if [[ ${incremental} -eq 1 ]] ; then
        upload_listed_site_files "${project_root_directory}/upload_files.txt"
    fi

    # uploads the project files
    echo
    echo "uploading project files"
    scp "${project_root_directory}"/package.json "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/
    scp "${site_canonical_source_code_file_list}" "${site_canonical_binary_file_list}" "${project_root_directory}"/"${siteId}"-custom-source-code-files "${project_root_directory}"/"${siteId}"-custom-binary-files "${project_root_directory}"/"${siteId}"-apps "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/
    echo ... done
    echo

    # uploads the canonical files
    upload_listed_site_files "${site_canonical_source_code_file_list}"
    upload_listed_site_files "${site_canonical_binary_file_list}"
    upload_listed_site_files "${project_root_directory}"/${siteId}-custom-source-code-files
    upload_listed_site_files "${project_root_directory}"/${siteId}-custom-binary-files

    if [[ ${incremental} -eq 0 ]] ; then
        if [[ $(picket-function-is-ipv6 --ip $ipAddress $argument_value_incremental $argument_value_debug) -eq 1 ]] ; then
            ssh ${userId}@${ipAddress} "touch ${DESTINATION_DIR}/all_files_uploaded"
        else
            ssh ${userId}@${ipAddress} "touch ${DESTINATION_DIR}/all_files_uploaded"
        fi
    fi
else
    picket-function-prepare --inputDir "${project_root_directory}" -s ${siteId} --siteNickname ${siteNickname} $argument_value_incremental $argument_value_debug

    # debugs upload of the server directory
    if [[ -d "${project_root_directory}"/server ]] ; then
        find "${project_root_directory}"/server -name .DS_Store
        ensure_directory_exists_for_file server/dummy.txt
        echo scp -r "${project_root_directory}"/server "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/
    fi

    # debugs upload of the library directory
    if [[ -d "${site_distribution_dir}"/lib ]] ; then
        find "${site_distribution_dir}"/lib -name .DS_Store
        echo scp -r "${site_distribution_dir}"/lib "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/
    fi

    # debugs upload of the project's npm package description
    echo scp "${project_root_directory}"/package.json "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/

    if [[ ${incremental} -eq 1 ]] ; then
        upload_listed_site_files "${project_root_directory}/upload_files.txt"
    fi

    upload_listed_site_files "${site_canonical_source_code_file_list}"
    upload_listed_site_files "${site_canonical_binary_file_list}"
    upload_listed_site_files "${project_root_directory}"/"${siteId}"-custom-source-code-files
    upload_listed_site_files "${project_root_directory}"/"${siteId}"-custom-binary-files
fi
