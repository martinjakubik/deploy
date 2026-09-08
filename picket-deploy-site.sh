#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId -u|--userId userId --ip ipAddress -c|--incremental -d|--debug"

# set up defaults
incremental=0
DEBUG=0

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
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

is_valid_site_id=false
if [[ ! $(picket-function-is-valid-site-id "${siteId}") ]] ; then
    echo site id is not valid, exiting
    exit 1
fi

echo -n "Trying to deploy site ''${siteId}''. "

does_site_exist_in_database=$(picket-function-does-site-exist-in-database --siteId "${siteId}")
if [[ $does_site_exist_in_database -eq 0 ]] ; then
    echo "Site does not exist. Stopping."
    exit 1
fi

echo

siteName=$(picket-function-get-site-project-root-from-id "$siteId" $argument_value_debug)
isValidSiteFullName=true
if [[ ! $isValidSiteFullName ]] ; then
    echo site name is not valid
	exit 1
fi

all_project_root=~/code/gitwork
STAGING_DIR=/var/x-www-staging
SITE_STAGING_DIR_ROOT="${STAGING_DIR}"/"${siteId}"
SITE_STAGING_DIR_SITE="${SITE_STAGING_DIR_ROOT}"/site
project_root_directory="${all_project_root}"/"$(picket-function-get-site-project-root-from-id $siteId $argument_value_debug)"

LIVE_DIR=/var/www
sitePackageRootDirectory="${LIVE_DIR}"/"${siteName}"
siteHypertextDirectory="${sitePackageRootDirectory}"/htdocs

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

print_command_to_move_single_file_from_staging_to_live () {
    single_file="$1"
    staging_directory="${SITE_STAGING_DIR_SITE}"
    live_directory="${siteHypertextDirectory}"
    if [[ -n "$2" && -n "$3" ]] ; then
        staging_directory="$2"
        live_directory="$3"
    fi
    echo "cp ${staging_directory}/${single_file} ${live_directory}/ ; rm ${staging_directory}/${single_file} ;"
}

install_listed_files () {
    file_listing_files_to_install="$1"
    path_to_file_in_site_staging_directory="${SITE_STAGING_DIR_SITE}"
    path_to_file_in_site_live_directory="${siteHypertextDirectory}"
    app=""
    if [[ -n "$2" ]] ; then
        app="$2"
        path_to_file_in_site_staging_directory="$SITE_STAGING_DIR_SITE/apps/$app/app"
        path_to_file_in_site_live_directory="$siteHypertextDirectory/apps/$app/app"
    fi

    echo
    echo "--------------------------------------------------------------------------------"
    echo "installing files listed in $file_listing_files_to_install"
    if [[ -e "$file_listing_files_to_install" ]] ; then
        file_array=()

        finished_reading_file=false
        until $finished_reading_file; do
            read -r || finished_reading_file=true
            file_array+=("$REPLY")
        done < "$file_listing_files_to_install"

        ssh_install_command=""
        for filename in "${file_array[@]}" ; do
            if [[ -n "${filename}" ]] ; then
                ensure_directory_exists_for_file "${path_to_file_in_site_live_directory}"/"${filename}"
                ssh_install_command+=" $(print_command_to_move_single_file_from_staging_to_live ${filename} ${path_to_file_in_site_staging_directory} ${path_to_file_in_site_live_directory})"
            fi
        done

        if [[ $DEBUG -eq 0 ]] ; then
            ssh -t ${userId}@${ipAddress} "$ssh_install_command"
        else
            echo ssh -t ${userId}@${ipAddress} "$ssh_install_command"
        fi
    else
        echo "the list of files $file_listing_files_to_install does not exist"
    fi

    echo ... done
    echo
}

clean_install_site_canonical_files () {
	if [[ ! -d "${sitePackageRootDirectory}" ]] ; then
		echo "${sitePackageRootDirectory} does not exist; creating it."
		ssh_make_directory_command="sudo mkdir ${sitePackageRootDirectory}"
	fi
	echo ssh -t ${userId}@${ipAddress} $ssh_make_directory_command
	if [[ ! -d "${siteHypertextDirectory}" ]] ; then
		echo "${siteHypertextDirectory} does not exist; creating it."
		ssh_make_directory_command="sudo mkdir ${siteHypertextDirectory}"
	fi
	echo ssh -t ${userId}@${ipAddress} $ssh_make_directory_command
	install_listed_files "${site_canonical_source_code_file_list}"
    install_listed_files "${site_canonical_binary_file_list}"
}

incremental_install_site_custom_content() {
	echo ignoring incremental content install
}

clean_install_site_custom_files() {
    install_listed_files "${project_root_directory}"/"${siteId}"-custom-source-code-files
    install_listed_files "${project_root_directory}"/"${siteId}"-custom-binary-files
}

clean_install_app_files() {
    app="$1"
    install_listed_files "${project_root_directory}"/site/apps/"${app}"-custom-source-code-files ${app}
}

delete_files_uploaded_marker() {
    if [[ -f "${SITE_STAGING_DIR_ROOT}"/all_files_uploaded ]] ; then
        rm "${SITE_STAGING_DIR_ROOT}"/all_files_uploaded
    fi
}

apps=()
apps+="cv"
if [[ $incremental -eq 0 ]] ; then
    clean_install_site_canonical_files
	clean_install_site_custom_files
	delete_files_uploaded_marker
    for app in "${apps[@]}" ; do
        clean_install_app_files "$app"
    done
elif [[ $incremental -eq 1 ]] ; then
    clean_install_site_canonical_files
	incremental_install_site_custom_content
	delete_files_uploaded_marker
fi

exit 0
