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
    source_code_or_binary_resource="$2"
    if [[ "$source_code_or_binary_resource" = "source_code" ]] ; then
        parent_dir="src"
    elif [[ "$source_code_or_binary_resource" = "binary_resource" ]] ; then
        parent_dir="resources"
    else
        echo parent directory for file collection of type "$source_code_or_binary_resource" not found
        exit 1
    fi

    echo ---
    echo "building files listed in $file_listing_files_to_build"
    if [[ -e "$file_listing_files_to_build" ]] ; then
        file_array=()

        while IFS= read -r line; do
            file_array+=($line)
        done < "$file_listing_files_to_build"

        for filename in "${file_array[@]}" ; do
            requested_filename="${project_root_directory}"/"${parent_dir}"/"$filename"
            if [[ -e "$requested_filename" ]] ; then
                if [[ ! -d "${site_distribution_directory}" ]] ; then
                    mkdir "${site_distribution_directory}"
                fi
                cp "${requested_filename}" "${site_distribution_directory}"/
            else
                echo the file: "$requested_filename" does not exist
            fi
        done
    else
        echo "the list of files $file_listing_files_to_build does not exist"
    fi
    echo ---
}

build_listed_source_code_files() {
    build_listed_files "$1" "source_code"
}

build_listed_binary_files() {
    build_listed_files "$1" "binary_resource"
}

build_listed_source_code_files "${site_canonical_source_code_file_list}"
build_listed_binary_files "${site_canonical_binary_file_list}"
build_listed_source_code_files ${project_root_directory}/${siteId}-custom-source-code-files
build_listed_binary_files ${project_root_directory}/${siteId}-custom-binary-files
