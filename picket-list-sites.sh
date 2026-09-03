#!/bin/bash
# sets up usage
USAGE="usage: $0"

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
        (-u) userId="$2"; shift;;
        (--userId) userId="$2"; shift;;
        (--ip) ipAddress="$2"; shift;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

file_listing_sites=$HOME/.picket/sites.db/sites
parent_path_to_file_listing_sites=$(dirname "${file_listing_sites}")

if [[ ! -d "${parent_path_to_file_listing_sites}" ]] ; then
    echo "no site database was found; check if $HOME/.picket/sites.db exists"
    exit 1
fi

echo
echo listing sites
echo

existing_site_array=()
finished_reading_file=false
until $finished_reading_file; do
    read -r || finished_reading_file=true
    if [[ -n "$REPLY" ]] ; then
        existing_site_array+=("$REPLY")
    fi
done < "${file_listing_sites}"

site_count=0
for siteId in "${existing_site_array[@]}" ; do
    site_count_padded=$site_count
    if [[ ${#site_count_padded} -lt 2 ]] ; then
        site_count_padded=00${site_count_padded}
    elif [[ ${#site_count_padded} -lt 3 ]] ; then
        site_count_padded=0${site_count_padded}
    fi
    echo ${site_count_padded}. "${siteId}"
    site_count=$(( site_count+1 ))
done

if [[ $site_count -gt 0 ]] ; then
    echo
    if [[ $site_count -eq 1 ]] ; then
        echo "... 1 site found"
    else
        echo "... $site_count sites found"
    fi
fi

exit 0
