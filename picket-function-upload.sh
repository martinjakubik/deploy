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
SITE_STAGING_DIR_ROOT="${STAGING_DIR}"/${siteId}
SITE_STAGING_DIR_SITE="${SITE_STAGING_DIR_ROOT}"/site
if [[ $(picket-function-is-ipv6 --ip $ipAddress $argument_value_incremental $argument_value_debug) -eq 1 ]] ; then
    DESTINATION_DIR_WITH_USER_AND_IP_ROOT=${userId}@\[${ipAddress}\]:"${SITE_STAGING_DIR_ROOT}"
else
    DESTINATION_DIR_WITH_USER_AND_IP_ROOT=${userId}@${ipAddress}:"${SITE_STAGING_DIR_ROOT}"
fi
DESTINATION_DIR_WITH_USER_AND_IP_SITE="${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/site
site_distribution_dir="${project_root_directory%/}"/site

does_canonical_source_code_file_list_exist=0
site_canonical_source_code_file_list="${project_root_directory%\/}"/site-canonical-source-code-files
if [[ -f "${site_canonical_source_code_file_list}" ]] ; then
    does_canonical_source_code_file_list_exist=1
elif [[ -f $HOME/.picket/site-canonical-source-code-files ]] ; then
    does_canonical_source_code_file_list_exist=1
    site_canonical_source_code_file_list=$HOME/.picket/site-canonical-source-code-files
fi

does_canonical_binary_file_list_exist=0
site_canonical_binary_file_list="${project_root_directory%\/}"/site-canonical-binary-files
if [[ -f "${site_canonical_binary_file_list}" ]] ; then
    does_canonical_binary_file_list_exist=1
elif [[ -f $HOME/.picket/site-canonical-binary-files ]] ; then
    does_canonical_binary_file_list_exist=1
    site_canonical_binary_file_list=$HOME/.picket/site-canonical-binary-files
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
    full_path_to_filename_to_check="$1"

    remoteTargetDirectory=$(dirname "${full_path_to_filename_to_check}")
    if printf '%s\0' "${existing_directory_array[@]}" | grep -Fxqz -- "${remoteTargetDirectory}" ; then
        is_directory_found_on_remote=1
    else
        is_directory_found_on_remote=0
    fi

    if [[ ! $is_directory_found_on_remote -eq 1 ]]; then
        if [[ $DEBUG -eq 0 ]] ; then
            ssh -t ${userId}@${ipAddress} "if [[ ! -d $remoteTargetDirectory ]] ; then  mkdir -p $remoteTargetDirectory ; fi"
        elif [[ $DEBUG -eq 1 ]] ; then
            echo ssh -t ${userId}@${ipAddress} "if [[ ! -d $remoteTargetDirectory ]] ; then echo creating remote directory $remoteTargetDirectory ; mkdir -p $remoteTargetDirectory ; fi"
        fi
        existing_directory_array+=("$remoteTargetDirectory")
    fi
}

upload_listed_files() {
    max_upload_count_before_throttle=4
    throttle_sleep_time_between_uploads=45s
    file_listing_files_to_upload="$1"
    remote_destination_directory="$DESTINATION_DIR_WITH_USER_AND_IP_SITE"
    app=""
    if [[ -n "$2" ]] ; then
        app="$2"
        remote_destination_directory="$DESTINATION_DIR_WITH_USER_AND_IP_SITE/apps/$app/app"
    fi

    echo
    echo "uploading files listed in $file_listing_files_to_upload"
    echo "--------------------------------------------------------------------------------"
    upload_count=0
    upload_count_in_set=0
    if [[ -e "$file_listing_files_to_upload" ]] ; then
        file_array=()

        finished_reading_file=false
        until $finished_reading_file; do
            read -r || finished_reading_file=true
            file_array+=("${REPLY/\\n/}")
        done < "$file_listing_files_to_upload"

        # constructs upload commands for all of the files listed in the file
        scp_command_array=()
        scp_upload_command="scp "
        for filename in "${file_array[@]}" ; do
            local_filename="${site_distribution_dir}"/"$filename"
            remote_full_path_to_file="${SITE_STAGING_DIR_ROOT}"/site/"${filename}"
            if [[ -n "$app" ]] ; then
                local_filename="${site_distribution_dir}/apps/${app}/app/${filename}"
                remote_full_path_to_file="${SITE_STAGING_DIR_ROOT}"/site/apps/"${app}"/app/"${filename}"
            fi
            if [[ -e "$local_filename" && -f "$local_filename" ]] ; then
                ensure_directory_exists_for_file "${remote_full_path_to_file}"
                if [[ $DEBUG -eq 0 ]] ; then
                    scp_upload_command+=" $local_filename"
                else
                    echo adding upload command for "$local_filename" to "${remote_destination_directory}"/"$filename"
                    scp_upload_command+=" $local_filename"
                fi
                upload_count=$(( upload_count+1 ))
                upload_count_in_set=$(( upload_count_in_set+1 ))
                echo $upload_count files added to upload command $upload_count_in_set files added in set
                if [[ $upload_count_in_set -gt $max_upload_count_before_throttle ]] ; then
                    # once max number of files is reached, saves the current scp_upload_command in an array scp_command_array, and starts a new one
                    scp_upload_command+=" ${remote_destination_directory}/"
                    echo "adding command $scp_upload_command to array"
                    scp_command_array+=("$scp_upload_command")
                    scp_upload_command="scp "
                    upload_count_in_set=0
                fi
            else
                echo the file: "$local_filename" does not exist
            fi
        done

        # adds the last upload command if there is one
        scp_upload_command+=" ${remote_destination_directory}/"
        echo "adding command $scp_upload_command to array"
        scp_command_array+=("$scp_upload_command")

        # loops through the scp upload commands
        echo "running all upload commands"
        for scp_upload_command in "${scp_command_array[@]}" ; do
            if [[ $DEBUG -eq 0 ]] ; then
                eval "$scp_upload_command"
            else
                echo "$scp_upload_command"
            fi
        done
    else
        echo "the list of files $file_listing_files_to_upload does not exist"
    fi
    echo "--------------------------------------------------------------------------------"
    echo ... done
    echo
}

if [[ $DEBUG -eq 0 ]] ; then
    picket-function-prepare --inputDir "${project_root_directory}" -s "${siteId}" --siteNickname "${siteNickname}" $argument_value_incremental $argument_value_debug

    # checks if a plain file already exists with the name of the destination directory
    ssh ${userId}@${ipAddress} "if [[ -f ${SITE_STAGING_DIR_ROOT} ]] ; then exit 1 ; fi"
    check_destination_directory_exit_code=$?
    if [[ $check_destination_directory_exit_code -eq 1 ]] ; then
        echo "a plain file called ${SITE_STAGING_DIR_ROOT} already exists; stopping."
        exit 1
    fi

    # uploads content to the server directory
    if [[ -d "${project_root_directory}"/server ]] ; then
        find "${project_root_directory}"/server -name .DS_Store -delete
        ensure_directory_exists_for_file "${SITE_STAGING_DIR_ROOT}"/server/dummy.txt
        echo
        echo "uploading server files"
        echo "--------------------------------------------------------------------------------"
        scp -r "${project_root_directory}"/server "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/
        echo "--------------------------------------------------------------------------------"
        echo ... done
        echo
    fi

    # uploads content to the library directory
    if [[ -d "${site_distribution_dir}"/lib ]] ; then
        find "${site_distribution_dir}"/lib -name .DS_Store -delete
        echo
        echo "uploading site library files"
        echo "--------------------------------------------------------------------------------"
        scp -r "${site_distribution_dir}"/lib "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/
        echo "--------------------------------------------------------------------------------"
        echo ... done
        echo
    fi

    if [[ ${incremental} -eq 1 ]] ; then
        upload_listed_files "${project_root_directory}/upload_files.txt"
    fi

    # uploads the project files
    echo
    echo "uploading project files"
    echo "--------------------------------------------------------------------------------"
    scp "${project_root_directory}"/package.json "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/
    scp "${site_canonical_source_code_file_list}" "${site_canonical_binary_file_list}" "${project_root_directory}"/"${siteId}"-custom-source-code-files "${project_root_directory}"/"${siteId}"-custom-binary-files "${project_root_directory}"/"${siteId}"-apps "${DESTINATION_DIR_WITH_USER_AND_IP_ROOT}"/
    echo "--------------------------------------------------------------------------------"
    echo ... done
    echo

    # uploads the canonical files
    upload_listed_files "${site_canonical_source_code_file_list}"
    upload_listed_files "${site_canonical_binary_file_list}"
    upload_listed_files "${project_root_directory}"/"${siteId}"-custom-source-code-files
    upload_listed_files "${project_root_directory}"/"${siteId}"-custom-binary-files

    apps=()
    if [[ $siteId = "stitle" ]] ; then
        apps+="cv"
    fi
    for app in "${apps[@]}" ; do
        ensure_directory_exists_for_file "${SITE_STAGING_DIR_ROOT}"/site/apps/"${app}/${app}"-custom-source-code-files
        scp "${project_root_directory}"/site/apps/"${app}"-custom-source-code-files "${DESTINATION_DIR_WITH_USER_AND_IP_SITE}"/apps/
        upload_listed_files "${project_root_directory}"/site/apps/"${app}"-custom-source-code-files "${app}"
    done

    if [[ ${incremental} -eq 0 ]] ; then
        ssh ${userId}@${ipAddress} "touch ${SITE_STAGING_DIR_ROOT}/all_files_uploaded"
    fi
else
    picket-function-prepare --inputDir "${project_root_directory}" -s "${siteId}" --siteNickname "${siteNickname}" $argument_value_incremental $argument_value_debug

    # debugs upload of the server directory
    if [[ -d "${project_root_directory}"/server ]] ; then
        find "${project_root_directory}"/server -name .DS_Store
        ensure_directory_exists_for_file "${SITE_STAGING_DIR_ROOT}"/server/dummy.txt
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
        upload_listed_files "${project_root_directory}/upload_files.txt"
    fi

    upload_listed_files "${site_canonical_source_code_file_list}"
    upload_listed_files "${site_canonical_binary_file_list}"
    upload_listed_files "${project_root_directory}"/"${siteId}"-custom-source-code-files
    upload_listed_files "${project_root_directory}"/"${siteId}"-custom-binary-files

    apps=()
    apps+="cv"
    for app in "${apps[@]}" ; do
        echo "scp ${project_root_directory}/${app}-custom-source-code-files ${DESTINATION_DIR_WITH_USER_AND_IP_SITE}/apps/${app}/"
        upload_listed_files "${project_root_directory}"/"${app}"-custom-source-code-files ${app}
    done
fi
