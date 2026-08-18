#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId -u|--userId userId --ip ipAddress -c|--incremental -d|--debug"

# set up defaults
incremental=0

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

siteName=$(picket-function-get-site-project-root-from-id "$siteId")
isValidSiteFullName=true
if [[ ! isValidSiteFullName ]] ; then
	exit 1
fi

STAGING_DIR=/var/x-www-staging
SITE_STAGING_DIR_ROOT="${STAGING_DIR}"/${siteId}
SITE_STAGING_DIR_SITE="${SITE_STAGING_DIR_ROOT}"/site

LIVE_DIR=/var/www
sitePackageRootDirectory=${LIVE_DIR}/${siteName}
siteHypertextDirectory=${sitePackageRootDirectory}/htdocs

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

move_single_file_from_staging_to_live () {
    single_file="$1"
    # if [[ -f ${SITE_STAGING_DIR_SITE}/${single_file} ]] ; then
        echo "sudo cp ${SITE_STAGING_DIR_SITE}/${single_file} ${siteHypertextDirectory}/ ; sudo rm ${SITE_STAGING_DIR_SITE}/${single_file} ;"
    # fi
}

install_listed_site_files () {
    # move_single_file_from_staging_to_live settings.png
    file_listing_files_to_install="$1"
    echo
    echo "installing files listed in $file_listing_files_to_install"
    if [[ -e "$file_listing_files_to_install" ]] ; then
        file_array=()

        while IFS= read -r line; do
            file_array+=($line)
        done < "$file_listing_files_to_install"

        ssh_install_command=""
        for filename in "${file_array[@]}" ; do
            # ensure_directory_exists_for_file site/"${requested_filename}"
            if [[ $DEBUG -eq 0 ]] ; then
                ssh_install_command+=" $(move_single_file_from_staging_to_live ${filename})"
            else
                echo installing "$filename"
            fi
        done
    else
        echo "the list of files $file_listing_files_to_install does not exist"
    fi
    echo ssh -t ${userId}@${ipAddress} "$ssh_install_command"
    echo ... done
    echo
}

clean_install_site_canonical_files () {
	if [[ ! -d ${sitePackageRootDirectory} ]] ; then
		echo "${sitePackageRootDirectory} does not exist; creating it."
		ssh_make_directory_command="sudo mkdir ${sitePackageRootDirectory}"
	fi
	echo ssh -t ${userId}@${ipAddress} $ssh_make_directory_command
	if [[ ! -d ${siteHypertextDirectory} ]] ; then
		echo "${siteHypertextDirectory} does not exist; creating it."
		ssh_make_directory_command="sudo mkdir ${siteHypertextDirectory}"
	fi
	echo ssh -t ${userId}@${ipAddress} $ssh_make_directory_command
	install_listed_site_files "${site_canonical_source_code_file_list}"
    install_listed_site_files "${site_canonical_binary_file_list}"
}

incremental_install_site_custom_content() {
	echo ignoring incremental content install
}

clean_install_site_custom_files() {
    install_listed_site_files "${project_root_directory}"/"${siteId}"-custom-source-code-files
    install_listed_site_files "${project_root_directory}"/"${siteId}"-custom-binary-files
}

delete_files_uploaded_marker() {
    if [[ -f ${SITE_STAGING_DIR_ROOT}/all_files_uploaded ]] ; then
        rm ${SITE_STAGING_DIR_ROOT}/all_files_uploaded
    fi
}

if [[ $incremental -eq 0 ]] ; then
    clean_install_site_canonical_files
	clean_install_site_custom_files
	delete_files_uploaded_marker
elif [[ $incremental -eq 1 ]] ; then
    clean_install_site_canonical_files
	incremental_install_site_custom_content
	delete_files_uploaded_marker
fi

exit 0
