#!/bin/bash
# sets up usage
USAGE="usage: $0 -c --incremental"

# set up defaults
incremental=0

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-c) incremental=1;;
		(--incremental) incremental=1;;
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

site_full_name=www.abcdhome.name
isValidSiteFullName=true
if [[ ! isValidSiteFullName ]] ; then
	exit 1
fi

live_site_dir=${site_full_name}

clean_install_site_base_content() {
	if [[ ! -d /var/www/${live_site_dir} ]] ; then
		echo "${live_site_dir} does not exist; please create it."
		return 1;
	fi
	mv ${static_site_upload_dir}/index.html /var/www/${live_site_dir}/htdocs/
    mv ${static_site_upload_dir}/screen.css /var/www/${live_site_dir}/htdocs/
    mv ${static_site_upload_dir}/logo.png /var/www/${live_site_dir}/htdocs/
    mv ${static_site_upload_dir}/background.png /var/www/${live_site_dir}/htdocs/
    mv ${static_site_upload_dir}/settings.png /var/www/${live_site_dir}/htdocs/
}

incremental_install_site_custom_content() {
	echo ignoring incremental content install
}

clean_install_site_custom_content() {
    echo ignoring clean install for custom site content
}

if [[ $incremental -eq 0 ]] ; then
    clear_install_site_base_content
	clean_install_site_custom_content
	rm ${static_site_upload_dir}/all_files_uploaded
elif [[ $incremental -eq 1 ]] ; then
	incremental_install_site_custom_content
fi
