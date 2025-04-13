#!/bin/bash
# sets up usage
USAGE="usage: $0 -c --incremental -d --debug"

# set up defaults
incremental=0

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(-c) incremental=1;;
		(--incremental) incremental=1;;
		(-d) DEBUG=1;;
		(--debug) DEBUG=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

is_from_directory_valid() {
	echo checking if directory valid
	if [ -z "$1" ] ; then
		echo "no from directory provided"
		return 1
	elif [ ! -d $1 ] ; then
		echo "from directory does not exist"
		return 1
	else
		return 0
	fi
}

move_file_from_to() {
	from_file=$1
	to_file=$2
	to_file_path=$(dirname $to_file)
	if [[ ! -d $to_file_path ]] ; then
		if [[ $DEBUG -eq 1 ]] ; then echo creating directory for $to_file ; fi
		mkdir -p $to_file_path
	fi
	if [[ $DEBUG -eq 1 ]] ; then
		echo moving $from_file to $to_file
	else
		echo really moving $from_file to $to_file
		mv $from_file $to_file
	fi
}

move_all_files_from_to() {
	from_dir=${1%/}
	to_dir=${2%/}
	if [[ $(is_from_directory_valid $from_dir $DEBUG) ]] ; then
	    if [[ $DEBUG -eq 1 ]] ; then echo --- ; echo moving files from ; echo $from_dir ; echo to ; echo $to_dir ; echo --- ; echo ; fi
		for file_name in $(find $from_dir -type f) ; do
			unique_path=${file_name#${from_dir}/}
			from_file="${from_dir}/${unique_path}"
			to_file="${to_dir}/${unique_path}"
			move_file_from_to $from_file $to_file
		done
	fi
}

incremental_install_content() {
	# installs planets in content/planets directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/planets ]] ; then
		mv /home/martin/stitlestaticsiteupload/content/planets/app/* /var/www/www.supertitle.org/htdocs/content/planets/app/
	fi

	# installs fractals in content/fractals directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/fractals ]] ; then
		mv /home/martin/stitlestaticsiteupload/content/fractals/app/* /var/www/www.supertitle.org/htdocs/content/fractals/app/
	fi

	# installs blaufisch in content/blaufisch directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/blaufisch/client/ ]] ; then
		mv /home/martin/stitlestaticsiteupload/content/blaufisch/app/client/index.html /var/www/www.supertitle.org/htdocs/content/blaufisch/app/client/
	fi

	if [[ -d /home/martin/stitlestaticsiteupload/content/blaufisch/client/css ]] ; then
		mv /home/martin/stitlestaticsiteupload/content/blaufisch/app/client/css/* /var/www/www.supertitle.org/htdocs/content/blaufisch/app/client/css/
	fi

	if [[ -d /home/martin/stitlestaticsiteupload/content/blaufisch/client/js ]] ; then
		mv /home/martin/stitlestaticsiteupload/content/blaufisch/app/client/js/* /var/www/www.supertitle.org/htdocs/content/blaufisch/app/client/js/
	fi

	if [[ -d /home/martin/stitlestaticsiteupload/content/blaufisch/client/media ]] ; then
		mv /home/martin/stitlestaticsiteupload/content/blaufisch/app/client/media/* /var/www/www.supertitle.org/htdocs/content/blaufisch/app/client/media/
	fi

	if [[ -d /home/martin/stitlestaticsiteupload/content/blaufisch/server/js ]] ; then
		mv /home/martin/stitlestaticsiteupload/content/blaufisch/app/server/js/* /var/www/www.supertitle.org/htdocs/content/blaufisch/app/server/js/
	fi

	# installs knights in content/knights directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/knights ]] ; then
		mv /home/martin/stitlestaticsiteupload/content/knights/app/* /var/www/www.supertitle.org/htdocs/content/knights/app/
	fi

	# installs war in content/war directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/war ]] ; then
		mv /home/martin/stitlestaticsiteupload/content/war/* /var/www/www.supertitle.org/htdocs/content/war/
	fi

	# installs books in content/books directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/books ]] ; then
		move_all_files_from_to /home/martin/stitlestaticsiteupload/content/books/app/ /var/www/www.supertitle.org/htdocs/content/books/app/
	fi
}

clean_install_content() {
	# cleanly installs planets in content/planets directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/planets ]] ; then
		rm -r /var/www/www.supertitle.org/htdocs/content/planets
	fi
	mv /home/martin/stitlestaticsiteupload/content/planets /var/www/www.supertitle.org/htdocs/content/

	# cleanly installs fractals in content/fractals directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/fractals ]] ; then
		rm -r /var/www/www.supertitle.org/htdocs/content/fractals
	fi
	mv /home/martin/stitlestaticsiteupload/content/fractals /var/www/www.supertitle.org/htdocs/content/

	# cleanly installs blaufisch in content/blaufisch directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/blaufisch ]] ; then
		rm -r /var/www/www.supertitle.org/htdocs/content/blaufisch
	fi
	mv /home/martin/stitlestaticsiteupload/content/blaufisch /var/www/www.supertitle.org/htdocs/content/

	# cleanly installs knights in content/knights directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/knights ]] ; then
		rm -r /var/www/www.supertitle.org/htdocs/content/knights
	fi
	mv /home/martin/stitlestaticsiteupload/content/knights /var/www/www.supertitle.org/htdocs/content/

	# cleanly installs war in content/war directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/war ]] ; then
		rm -r /var/www/www.supertitle.org/htdocs/content/war
	fi
	mv /home/martin/stitlestaticsiteupload/content/war /var/www/www.supertitle.org/htdocs/content/

	# cleanly installs books in content/books directory
	if [[ -d /home/martin/stitlestaticsiteupload/content/books ]] ; then
		rm -r /var/www/www.supertitle.org/htdocs/content/books
	fi
	mv /home/martin/stitlestaticsiteupload/content/books /var/www/www.supertitle.org/htdocs/content/
}

# installs server
if [[ $DEBUG -eq 1 ]] ; then
	echo installing server
else
	if [[ -d /var/www/www.supertitle.org/server ]] ; then
		rm -r /var/www/www.supertitle.org/server
	fi
	mv /home/martin/stitlestaticsiteupload/server /var/www/www.supertitle.org/
	chmod a+x /var/www/www.supertitle.org/server/index.js
fi

# installs package files
mv /home/martin/stitlestaticsiteupload/package.json /var/www/www.supertitle.org/
mv /home/martin/stitlestaticsiteupload/postinstall.js /var/www/www.supertitle.org/
starting_directory=$PWD
cd /var/www/www.supertitle.org/
npm install
cd $starting_directory

# installs libraries for home page
if [[ $DEBUG -eq 1 ]] ; then
	echo installing libraries
else
	if [[ -d /var/www/www.supertitle.org/htdocs/lib ]] ; then
		rm -r /var/www/www.supertitle.org/htdocs/lib
	fi
	mv /home/martin/stitlestaticsiteupload/lib /var/www/www.supertitle.org/htdocs/
fi

# installs web root files in web root directory
mv /home/martin/stitlestaticsiteupload/index.html /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/robots.txt /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/screen.css /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/app.js /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/title.png /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/logo.png /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/background.png /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/settings.png /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/up.png /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/clockwise.png /var/www/www.supertitle.org/htdocs/
mv /home/martin/stitlestaticsiteupload/counterclockwise.png /var/www/www.supertitle.org/htdocs/

if [[ $incremental -eq 0 ]] ; then
	clean_install_content
	rm /home/martin/stitlestaticsiteupload/all_files_uploaded
elif [[ $incremental -eq 1 ]] ; then
	incremental_install_content
fi
