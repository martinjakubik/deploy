#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId -u|--userId userId --ip ipAddress -d|--debug"

# sets up defaults
DEBUG=0
project_root_directory=~/project_root_directory
siteId=abcd

# parses and reads command line arguments
while [ $# -gt 0 ]
do
    case "$1" in
        (-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
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

argument_value_debug=""
if [[ $DEBUG -eq 1 ]] ; then
    argument_value_debug="--debug"
fi

all_project_root=~/code/gitwork
STAGING_DIR=/var/x-www-staging
SITE_STAGING_DIR_ROOT="${STAGING_DIR}"/"${siteId}"
SITE_STAGING_DIR_SITE="${SITE_STAGING_DIR_ROOT}"/site
SITE_STAGING_DIR_WITH_USER_AND_IP_ROOT=${userId}@${ipAddress}:"${SITE_STAGING_DIR_ROOT}"
SITE_STAGING_DIR_WITH_USER_AND_IP_SITE=${userId}@${ipAddress}:"${SITE_STAGING_DIR_SITE}"
project_root_directory="${all_project_root}"/"$(picket-function-get-site-project-root-from-id $siteId $argument_value_debug)"

if [[ ! -d "$project_root_directory" ]] ; then
    echo the directory "$project_root_directory" does not exist
    exit 1
fi

does_canonical_source_code_file_list_exist=0
site_canonical_source_code_file_list=site-canonical-source-code-files
if [[ -f "${site_canonical_source_code_file_list}" ]] ; then
    does_canonical_source_code_file_list_exist=1
elif [[ -f $HOME/.picket/site-canonical-source-code-files ]] ; then
    does_canonical_source_code_file_list_exist=1
    site_canonical_source_code_file_list=$HOME/.picket/site-canonical-source-code-files
fi

does_canonical_binary_file_list_exist=0
site_canonical_binary_file_list=site-canonical-binary-files
if [[ -f "${site_canonical_binary_file_list}" ]] ; then
    does_canonical_binary_file_list_exist=1
elif [[ -f $HOME/.picket/site-canonical-binary-files ]] ; then
    does_canonical_binary_file_list_exist=1
    site_canonical_binary_file_list=$HOME/.picket/site-canonical-binary-files
fi

echo --------------------------------------------------------------------------------
echo script: $0
echo you entered values
echo   "site dir                    : ${SITE_STAGING_DIR_WITH_USER_AND_IP_ROOT}"
echo   "site ID                     : ${siteId}"
echo   "user                        : ${userId}"
echo   "IP address                  : ${ipAddress}"
echo --------------------------------------------------------------------------------
echo

existing_directory_array=()

delete_listed_site_files() {
    file_listing_files_in_site_stage="$1"
    echo
    echo "deleting files listed in $file_listing_files_in_site_stage"
    if [[ -e "$file_listing_files_in_site_stage" ]] ; then
        file_array=()

        finished_reading_file=false
        until $finished_reading_file; do
            read -r || finished_reading_file=true
            file_array+=("$REPLY")
        done < "$file_listing_files_in_site_stage"

        ssh_delete_command="rm"
        existing_file_array=()
        for filename in "${file_array[@]}" ; do
            if [[ $DEBUG -eq 0 ]] ; then
                existing_file_array+=("$filename")
            fi
        done
        for existing_filename in "${existing_file_array[@]}" ; do
            if [[ $DEBUG -eq 0 ]] ; then
                ssh_delete_command+=" ${SITE_STAGING_DIR_SITE}/$existing_filename"
            else
                echo deleting "${SITE_STAGING_DIR_SITE}"/"$existing_filename"
            fi
        done
        ssh -t ${userId}@${ipAddress} "$ssh_delete_command"
    else
        echo "the list of files $file_listing_files_in_site_stage does not exist"
    fi
    echo ... done
    echo
}

if [[ $DEBUG -eq 0 ]] ; then
    # deletes content from the server directory
    if [[ -d "${project_root_directory}"/server ]] ; then
        find "${project_root_directory}"/server -name .DS_Store -delete
        # scp -r "${project_root_directory}"/server "${SITE_STAGING_DIR_WITH_USER_AND_IP_ROOT}"/
    fi

    # deletes content from the library directory
    if [[ -d "${site_distribution_dir}"/lib ]] ; then
        find "${site_distribution_dir}"/lib -name .DS_Store -delete
        # scp -r "${site_distribution_dir}"/lib "${SITE_STAGING_DIR_WITH_USER_AND_IP_ROOT}"/
    fi

    # deletes the project's npm package description
    # scp "${project_root_directory}"/package.json "${SITE_STAGING_DIR_WITH_USER_AND_IP_ROOT}"/

    delete_listed_site_files "${project_root_directory}/upload_files.txt"

    # deletes the site's metadata files
    # scp "${site_canonical_source_code_file_list}" "${site_canonical_binary_file_list}" "${project_root_directory}"/"${siteId}"-custom-source-code-files "${project_root_directory}"/"${siteId}"-custom-binary-files "${project_root_directory}"/"${siteId}"-apps "${SITE_STAGING_DIR_WITH_USER_AND_IP_ROOT}"/

    # deletes the canonical files
    delete_listed_site_files "${site_canonical_source_code_file_list}"
    delete_listed_site_files "${site_canonical_binary_file_list}"
    delete_listed_site_files "${project_root_directory}"/"${siteId}"-custom-source-code-files
    delete_listed_site_files "${project_root_directory}"/"${siteId}"-custom-binary-files

    ssh ${userId}@${ipAddress} "rm ${SITE_STAGING_DIR_ROOT}/all_files_uploaded"
else
    # debugs delete of the library directory
    if [[ -d "${site_distribution_dir}"/lib ]] ; then
        find "${site_distribution_dir}"/lib -name .DS_Store
        echo scp -r "${site_distribution_dir}"/lib "${SITE_STAGING_DIR_WITH_USER_AND_IP_ROOT}"/
    fi

    # debugs delete of the project's npm package description
    echo scp "${project_root_directory}"/package.json "${SITE_STAGING_DIR_WITH_USER_AND_IP_ROOT}"/

    delete_listed_site_files "${project_root_directory}/upload_files.txt"

    delete_listed_site_files "${site_canonical_source_code_file_list}"
    delete_listed_site_files "${site_canonical_binary_file_list}"
    delete_listed_site_files "${project_root_directory}"/"${siteId}"-custom-source-code-files
    delete_listed_site_files "${project_root_directory}"/"${siteId}"-custom-binary-files
fi
