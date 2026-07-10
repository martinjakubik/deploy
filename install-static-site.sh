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
        (-u) userId="$2"; shift;;
        (--userId) userId="$2"; shift;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

clean_install_site_base_content() {
	mv ${static_site_upload_dir}/index.html /var/www/www.fizasport.com/htdocs/
    mv ${static_site_upload_dir}/screen.css /var/www/www.fizasport.com/htdocs/
    mv ${static_site_upload_dir}/logo.png /var/www/www.fizasport.com/htdocs/
    mv ${static_site_upload_dir}/background.png /var/www/www.fizasport.com/htdocs/
    mv ${static_site_upload_dir}/settings.png /var/www/www.fizasport.com/htdocs/
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
