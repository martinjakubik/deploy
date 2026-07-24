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

clean_install_site_base_content() {
	if [[ ! -d /var/www/${sitePackageRootDirectory} ]] ; then
		echo "${sitePackageRootDirectory} does not exist; please create it."
		return 1;
	fi
	mv ${siteStagingDirectory}/index.html /var/www/${siteHypertextDirectory}/
    mv ${siteStagingDirectory}/screen.css /var/www/${siteHypertextDirectory}/
    mv ${siteStagingDirectory}/logo.png /var/www/${siteHypertextDirectory}/
    mv ${siteStagingDirectory}/background.png /var/www/${siteHypertextDirectory}/
    mv ${siteStagingDirectory}/settings.png /var/www/${siteHypertextDirectory}/
}

incremental_install_site_custom_content() {
	echo ignoring incremental content install
}

clean_install_site_custom_content() {
    echo ignoring clean install for custom site content
}

if [[ $incremental -eq 0 ]] ; then
    clean_install_site_base_content
	clean_install_site_custom_content
	rm ${siteStagingDirectory}/all_files_uploaded
elif [[ $incremental -eq 1 ]] ; then
	incremental_install_site_custom_content
fi
