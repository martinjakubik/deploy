#!/bin/bash
# sets up usage
USAGE="usage: $0 -i|--inputDir project_root_directory -s|--siteId siteId --siteNickname siteNickname -u|--userId userId --ip ipAddress -c|--incremental -t|--throttle -d|--debug"

# sets up defaults
DEBUG=0
THROTTLE=0
project_root_directory=~/project_root_directory
siteId=abcd
siteNickname=abcdhome
destinationDir=~/destinationDir
incremental=0
max_upload_count_before_throttle=5
throttle_sleep_time_between_uploads=10s

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
        (-t) THROTTLE=1;;
        (--throttle) THROTTLE=1;;
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

add_file_to_current_scp_command() {
    ensure_directory_exists_for_file "${remote_full_path_to_file}"
    scp_upload_command+=" $local_filename"
    upload_count=$(( upload_count+1 ))
    upload_count_in_set=$(( upload_count_in_set+1 ))
    if [[ $DEBUG -eq 1 ]] ; then echo $upload_count files added to upload command $upload_count_in_set files added in set ; fi
}

finish_scp_command_and_add_file_to_new_scp_command() {
    if [[ $upload_count -gt 0 ]] ; then
        scp_upload_command+=" ${remote_destination_directory}/"
        if [[ -n "${path_to_previous_file}" ]] ; then echo "appending path to previous file \"${path_to_previous_file}\" to command" ; scp_upload_command+="${path_to_previous_file}/" ; fi
        if [[ $DEBUG -eq 1 && "$1" = "max_count_reached" ]] ; then echo "maximum count reached; adding previous command $scp_upload_command to array" ;
        elif [[ $DEBUG -eq 1 && "$1" = "directory_changed" ]] ; then echo "directory changed; adding previous command $scp_upload_command to array" ;
        elif [[ $DEBUG -eq 1 ]] ; then echo "adding previous command $scp_upload_command to array" ; fi
        scp_command_array+=("$scp_upload_command")
    fi
    ensure_directory_exists_for_file "${remote_full_path_to_file}"
    scp_upload_command="scp ${local_filename}"
    upload_count=$(( upload_count+1 ))
    upload_count_in_set=1
    if [[ $DEBUG -eq 1 ]] ; then echo $upload_count files added to upload command $upload_count_in_set files added in set ; fi
}

upload_listed_files() {
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
        path_to_previous_file=""
        for filename in "${file_array[@]}" ; do
            local_filename="${site_distribution_dir}"/"$filename"
            remote_full_path_to_file="${SITE_STAGING_DIR_ROOT}"/site/"${filename}"
            path_to_current_file=""
            if [[ -n "$app" ]] ; then
                local_filename="${site_distribution_dir}/apps/${app}/app/${filename}"
                remote_full_path_to_file="${SITE_STAGING_DIR_ROOT}"/site/apps/"${app}"/app/"${filename}"
            fi
            if [[ -n "${filename}" && -f "$local_filename" ]] ; then
                path_to_current_file="$(dirname $filename)"
                if [[ $DEBUG -eq 1 ]] ; then echo ; echo "adding upload command for \""${filename}"\"" ; echo ; fi

                if [[ "$path_to_current_file" == "${path_to_previous_file}" && $upload_count_in_set -lt $max_upload_count_before_throttle ]] ; then
                    add_file_to_current_scp_command;
                elif [[ "$path_to_current_file" == "${path_to_previous_file}" && $upload_count_in_set -ge $max_upload_count_before_throttle ]] ; then
                    finish_scp_command_and_add_file_to_new_scp_command "max_count_reached" ;
                elif [[ "$path_to_current_file" != "${path_to_previous_file}" && $upload_count_in_set -lt $max_upload_count_before_throttle ]] ; then
                    finish_scp_command_and_add_file_to_new_scp_command "directory_changed" ;
                elif [[ "$path_to_current_file" != "${path_to_previous_file}" && $upload_count_in_set -ge $max_upload_count_before_throttle ]] ; then
                    finish_scp_command_and_add_file_to_new_scp_command "directory_changed" ;
                fi
            else
                echo the file: \""$filename"\" does not exist
            fi
            path_to_previous_file="${path_to_current_file}"
        done

        # adds the last upload command if there is one
        if [[ upload_count_in_set -gt 0 ]] ; then
            scp_upload_command+=" ${remote_destination_directory}/"
            if [[ $DEBUG -eq 1 ]] ; then echo "adding leftover command $scp_upload_command to array" ; fi
            scp_command_array+=("$scp_upload_command")
        fi

        # loops through the scp upload commands
        if [[ $DEBUG -eq 1 ]] ; then echo ; echo "running all upload commands" ; echo ; fi
        if [[ "${#scp_command_array[@]}" -gt 0 ]] ; then
            upload_run_count=0
            for scp_upload_command in "${scp_command_array[@]}" ; do
                if [[ $DEBUG -eq 1 ]] ; then
                    echo "$scp_upload_command"
                    if [[ $THROTTLE -eq 1 && upload_run_count -gt $max_upload_count_before_throttle ]] ; then echo "sleeping $throttle_sleep_time_between_uploads" ; upload_run_count=0 ; fi
                else
                    eval "$scp_upload_command"
                    if [[ $THROTTLE -eq 1 && upload_run_count -gt $max_upload_count_before_throttle ]] ; then sleep $throttle_sleep_time_between_uploads ; upload_run_count=0 ; fi
                fi
                upload_run_count=$(( upload_run_count+1 ))
            done
        else
            echo "... There were no upload commands to run."
        fi
    else
        echo "The list of files \"$file_listing_files_to_upload\" does not exist."
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
    if [[ $THROTTLE -eq 1 ]] ; then echo "sleeping $throttle_sleep_time_between_uploads" ; sleep $throttle_sleep_time_between_uploads ; fi

    upload_listed_files "${site_canonical_binary_file_list}"
    if [[ $THROTTLE -eq 1 ]] ; then echo "sleeping $throttle_sleep_time_between_uploads" ; sleep $throttle_sleep_time_between_uploads ; fi

    upload_listed_files "${project_root_directory}"/"${siteId}"-custom-source-code-files
    if [[ $THROTTLE -eq 1 ]] ; then echo "sleeping $throttle_sleep_time_between_uploads" ; sleep $throttle_sleep_time_between_uploads ; fi

    upload_listed_files "${project_root_directory}"/"${siteId}"-custom-binary-files
    if [[ $THROTTLE -eq 1 ]] ; then echo "sleeping $throttle_sleep_time_between_uploads" ; sleep $throttle_sleep_time_between_uploads ; fi

    file_listing_apps=$HOME/.picket/sites.db/"${siteId}"
    existing_app_array=()
    finished_reading_file=false
    until $finished_reading_file; do
        read -r || finished_reading_file=true
        if [[ -n "$REPLY" ]] ; then
            existing_app_array+=("$REPLY")
        fi
    done < "${file_listing_apps}"

    for appId in "${existing_app_array[@]}" ; do
        ensure_directory_exists_for_file "${SITE_STAGING_DIR_ROOT}"/site/apps/"${appId}/${appId}"-custom-source-code-files
        scp "${project_root_directory}"/site/apps/"${appId}"/"${appId}"-custom-source-code-files "${DESTINATION_DIR_WITH_USER_AND_IP_SITE}"/apps/"${appId}"/
        scp "${project_root_directory}"/site/apps/"${appId}"/"${app}"-custom-binary-files "${DESTINATION_DIR_WITH_USER_AND_IP_SITE}"/apps/"${appId}"/
        upload_listed_files "${project_root_directory}"/site/apps/"${appId}"/"${appId}"-custom-source-code-files "${appId}"
        upload_listed_files "${project_root_directory}"/site/apps/"${appId}"/"${appId}"-custom-binary-files "${appId}"
        if [[ $THROTTLE -eq 1 ]] ; then echo "sleeping $throttle_sleep_time_between_uploads" ; sleep $throttle_sleep_time_between_uploads ; fi
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

    file_listing_apps=$HOME/.picket/sites.db/"${siteId}"
    existing_app_array=()
    finished_reading_file=false
    until $finished_reading_file; do
        read -r || finished_reading_file=true
        if [[ -n "$REPLY" ]] ; then
            existing_app_array+=("$REPLY")
        fi
    done < "${file_listing_apps}"

    for appId in "${existing_app_array[@]}" ; do
        echo "scp ${project_root_directory}/site/apps/${appId}/${appId}-custom-source-code-files ${DESTINATION_DIR_WITH_USER_AND_IP_SITE}/apps/${appId}/"
        echo "scp ${project_root_directory}/site/apps/${appId}/${appId}-custom-binary-files ${DESTINATION_DIR_WITH_USER_AND_IP_SITE}/apps/${appId}"
        upload_listed_files "${project_root_directory}"/site/apps/"${appId}"/"${appId}"-custom-source-code-files ${appId}
        upload_listed_files "${project_root_directory}"/site/apps/"${appId}"/"${appId}"-custom-binary-files ${appId}
    done
fi
