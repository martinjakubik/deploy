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
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

incremental_install_content() {
	echo ignoring incremental content install
}

clean_install_content() {
    echo ignoring clean install for custom site content
}

# installs web root files in web root directory
mv /home/martin/fizastaticsiteupload/index.html /var/www/www.fizasport.com/htdocs/
mv /home/martin/fizastaticsiteupload/rules.html /var/www/www.fizasport.com/htdocs/
mv /home/martin/fizastaticsiteupload/screen.css /var/www/www.fizasport.com/htdocs/
mv /home/martin/fizastaticsiteupload/logo.png /var/www/www.fizasport.com/htdocs/
mv /home/martin/fizastaticsiteupload/background.png /var/www/www.fizasport.com/htdocs/
mv /home/martin/fizastaticsiteupload/settings.png /var/www/www.fizasport.com/htdocs/
mv /home/martin/fizastaticsiteupload/fizasport-0-rules-110-rule-summary.png /var/www/www.fizasport.com/htdocs/
mv /home/martin/fizastaticsiteupload/fizasport-0-home-010-home-playing.png /var/www/www.fizasport.com/htdocs/

if [[ $incremental -eq 0 ]] ; then
	clean_install_content
	rm /home/martin/fizastaticsiteupload/all_files_uploaded
elif [[ $incremental -eq 1 ]] ; then
	incremental_install_content
fi
