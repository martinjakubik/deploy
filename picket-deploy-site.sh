#!/bin/bash
# sets up usage
USAGE="usage: $0 -s|--siteId siteId -c|--incremental"

# set up defaults
incremental=0

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
		(-c) incremental=1;;
		(--incremental) incremental=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

siteName=www.abcdhome.name
isValidSiteFullName=true
if [[ ! isValidSiteFullName ]] ; then
	exit 1
fi

STAGING_DIR=/var/x-www-staging
siteStagingDirectory=${STAGING_DIR}/${siteId}

LIVE_DIR=/var/www
sitePackageRootDirectory=${LIVE_DIR}/${siteName}
siteHypertextDirectory=${sitePackageRootDirectory}/htdocs

clean_install_site_canonical_files () {
	if [[ ! -d ${sitePackageRootDirectory} ]] ; then
		echo "${sitePackageRootDirectory} does not exist; creating it."
		mkdir "${sitePackageRootDirectory}"
	fi
	if [[ ! -d ${siteHypertextDirectory} ]] ; then
		echo "${siteHypertextDirectory} does not exist; creating it."
		mkdir "${siteHypertextDirectory}"
	fi
	mv ${siteStagingDirectory}/index.html ${siteHypertextDirectory}/
    mv ${siteStagingDirectory}/screen.css ${siteHypertextDirectory}/
    mv ${siteStagingDirectory}/logo.png ${siteHypertextDirectory}/
    mv ${siteStagingDirectory}/background.png ${siteHypertextDirectory}/
    mv ${siteStagingDirectory}/settings.png ${siteHypertextDirectory}/
}

incremental_install_site_custom_content() {
	echo ignoring incremental content install
}

clean_install_site_custom_files() {
    echo ignoring clean install for custom site content
}

delete_files_uploaded_marker() {
    if [[ -f ${siteStagingDirectory}/all_files_uploaded ]] ; then
        rm ${siteStagingDirectory}/all_files_uploaded
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
