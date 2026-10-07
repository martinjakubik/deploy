#!/bin/bash

test_case="$1"
echo case "$test_case"

picket_configuration_file="testing-config.0.picket"
if [[ -n "${picket_path_to_configuration_file}" && -f "${picket_path_to_configuration_file}" ]] ; then
    picket_configuration_file="${picket_path_to_configuration_file}"
fi

source picket-function-read-configuration "${picket_configuration_file}"

command_stage__no_arguments__user_file_too_big() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    echo -n > "${path_to_picket_database}"/user
    for (( i=0 ; i < 128 ; i=i+1 )) ; do
        echo -n 0 >> "${path_to_picket_database}"/user
    done
}

command_logout__no_arguments__no_user_logged_in() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    echo -n > "${path_to_picket_database}"/user
}

command_logout__no_arguments__user_logged_in() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    echo -n "test_user_id" > "${path_to_picket_database}"/user
}

command_deploy__user_not_logged_in__valid_site_argument() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    echo -n > "${path_to_picket_database}"/user
}

create_site() {
    if [[ -f "${path_to_picket_database}"/sites.db/sites ]] ; then
        rm "${path_to_picket_database}"/sites.db/sites
    fi
    if [[ -f "${path_to_picket_database}"/sites.db/site0 ]] ; then
        rm "${path_to_picket_database}"/sites.db/site0
    fi
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
}

case "$test_case" in
    ("command stage, valid site argument; user file too big") command_stage__no_arguments__user_file_too_big;;
    ("command logout, no arguments; no user logged in") command_logout__no_arguments__no_user_logged_in;;
    ("command logout, no arguments; user logged in") command_logout__no_arguments__user_logged_in;;
    ("command deploy, user not logged in, valid site argument") command_deploy__user_not_logged_in__valid_site_argument;;
    ("create site") create_site;;
esac

exit 0
