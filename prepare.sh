#!/bin/bash

# sets up usage
USAGE="usage: $0 -i|--inputDir project_root_directory s|--siteId siteId --siteNickname siteNickname -d|--debug"

# sets up defaults
DEBUG=0
project_root_directory=~/project_root_directory
siteId=abcd
siteNickname=abcdhome

# parses and reads command line arguments
while [ $# -gt 0 ]
do
  case "$1" in
    (-i) project_root_directory="${2%\/}"; shift;;
    (--inputDir) project_root_directory="${2%\/}"; shift;;
    (-s) siteId="$2"; shift;;
    (--siteId) siteId="$2"; shift;;
    (--siteNickname) siteNickname="$2"; shift;;
    (-d) DEBUG=1;;
    (--debug) DEBUG=1;;
    (-*) echo >&2 ${USAGE}
    exit 1;;
  esac
  shift
done

site_distribution_directory=${project_root_directory%\/}/site

echo --------------------------------------------------------------------------------
echo script: $0
echo you entered values
echo   "From project root dir       : ${project_root_directory}"
echo   "site nickname               : ${siteNickname}"
echo   "site ID                     : ${siteId}"
echo --------------------------------------------------------------------------------
echo

build_listed_files() {
    file_listing_files_to_build="$1"
    echo ---
    echo "building files listed in $file_listing_files_to_build"
    if [[ -e "$file_listing_files_to_build" ]] ; then
        file_array=()

        while IFS= read -r line; do
            file_array+=($line)
        done < "$file_listing_files_to_build"

        for filename in "${file_array[@]}" ; do
            requested_filename="${project_root_directory}"/"$filename"
            if [[ -e "$requested_filename" ]] ; then
                if [[ ! -d "${site_distribution_directory}" ]] ; then
                    mkdir "${site_distribution_directory}"
                fi
                mv "${requested_filename}" "${site_distribution_directory}"/
            else
                echo the file: "$requested_filename" does not exist
            fi
        done
    else
        echo "the list of files $file_listing_files_to_build does not exist"
    fi
    echo ---
}

build_listed_files site_canonical_files
build_listed_files ${project_root_directory}/${siteId}-custom-files

if [[ $DEBUG -eq 0 ]] ; then
    cp ${project_root_directory}/resources/${siteNickname}-title.png ${site_distribution_directory}/title.png
    cp ${project_root_directory}/resources/${siteNickname}-logo.png ${site_distribution_directory}/logo.png
    cp ${project_root_directory}/resources/${siteNickname}-background.png ${site_distribution_directory}/background.png
    cp ${project_root_directory}/resources/${siteNickname}-background-tile.png ${site_distribution_directory}/background-tile.png
    cp ${project_root_directory}/resources/${siteNickname}-settings.png ${site_distribution_directory}/settings.png
    cp ${project_root_directory}/resources/${siteNickname}-volume-on.png ${site_distribution_directory}/volume-on.png
    cp ${project_root_directory}/resources/${siteNickname}-volume-off.png ${site_distribution_directory}/volume-off.png
else
    echo cp ${project_root_directory}/resources/${siteNickname}-title.png ${site_distribution_directory}/title.png
    echo cp ${project_root_directory}/resources/${siteNickname}-logo.png ${site_distribution_directory}/logo.png
    echo cp ${project_root_directory}/resources/${siteNickname}-background.png ${site_distribution_directory}/background.png
    echo cp ${project_root_directory}/resources/${siteNickname}-background-tile.png ${site_distribution_directory}/background-tile.png
    echo cp ${project_root_directory}/resources/${siteNickname}-settings.png ${site_distribution_directory}/settings.png
    echo cp ${project_root_directory}/resources/${siteNickname}-volume-on.png ${site_distribution_directory}/volume-on.png
    echo cp ${project_root_directory}/resources/${siteNickname}-volume-off.png ${site_distribution_directory}/volume-off.png
fi
