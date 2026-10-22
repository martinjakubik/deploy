#!/bin/bash

test_case="$1"

picket_configuration_file="testing-config.0.picket"
if [[ -n "${picket_path_to_configuration_file}" && -f "${picket_path_to_configuration_file}" ]] ; then
    picket_configuration_file="${picket_path_to_configuration_file}"
fi

source picket-function-read-configuration "${picket_configuration_file}"

command_stage__no_arguments__user_file_too_big() {
    if [[ -f "${path_to_picket_database}"/user ]] ; then
        rm "${path_to_picket_database}"/user
    fi
}

command_logout__no_arguments__no_user_logged_in() {
    if [[ -f "${path_to_picket_database}"/user ]] ; then
        rm "${path_to_picket_database}"/user
    fi
}

command_logout__no_arguments__user_logged_in() {
    if [[ -f "${path_to_picket_database}"/user ]] ; then
        rm "${path_to_picket_database}"/user
    fi
}

command_deploy__user_not_logged_in__valid_site_argument() {
    if [[ -f "${path_to_picket_database}"/user ]] ; then
        rm "${path_to_picket_database}"/user
    fi
}

valid_site_id() {
    if [[ -f "${path_to_picket_database}"/sites.db/sites ]] ; then
        rm "${path_to_picket_database}"/sites.db/sites
    fi
    if [[ -f "${path_to_picket_database}"/sites.db/site0 ]] ; then
        rm "${path_to_picket_database}"/sites.db/site0
    fi
}

create_site() {
    if [[ -f "${path_to_picket_database}"/sites.db/sites ]] ; then
        rm "${path_to_picket_database}"/sites.db/sites
    fi
    if [[ -f "${path_to_picket_database}"/sites.db/site0 ]] ; then
        rm "${path_to_picket_database}"/sites.db/site0
    fi
}

list_sites__one_site() {
    if [[ -f "${path_to_picket_database}"/sites.db/sites ]] ; then
        rm "${path_to_picket_database}/sites.db/sites"
    fi
    if [[ -f "${path_to_picket_database}"/sites.db/site0 ]] ; then
        rm "${path_to_picket_database}/sites.db/site0"
    fi
}

list_sites__two_sites() {
    if [[ -f "${path_to_picket_database}"/sites.db/sites ]] ; then
        rm "${path_to_picket_database}/sites.db/sites"
    fi
    if [[ -f "${path_to_picket_database}"/sites.db/site0 ]] ; then
        rm "${path_to_picket_database}/sites.db/site0"
    fi
    if [[ -f "${path_to_picket_database}"/sites.db/site1 ]] ; then
        rm "${path_to_picket_database}/sites.db/site1"
    fi
}

create_app() {
    if [[ -f "${path_to_picket_database}"/apps.db/apps ]] ; then
        rm "${path_to_picket_database}"/apps.db/apps
    fi
}

create_app_valid_app_ID() {
    if [[ -f "${path_to_picket_database}"/sites.db/sites ]] ; then
        rm "${path_to_picket_database}"/sites.db/sites
    fi
    if [[ -f "${path_to_picket_database}"/sites.db/site0 ]] ; then
        rm "${path_to_picket_database}"/sites.db/site0
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/apps ]] ; then
        rm "${path_to_picket_database}"/apps.db/apps
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/apps ]] ; then
        rm "${path_to_picket_database}"/apps.db/app0
    fi
}

update_app() {
    if [[ -f "${path_to_picket_database}"/sites.db/sites ]] ; then
        rm "${path_to_picket_database}"/sites.db/sites
    fi
    if [[ -f "${path_to_picket_database}"/sites.db/site0 ]] ; then
        rm "${path_to_picket_database}"/sites.db/site0
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/apps ]] ; then
        rm "${path_to_picket_database}"/apps.db/apps
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/apps ]] ; then
        rm "${path_to_picket_database}"/apps.db/app0
    fi
}

get_app_project_root_from_ID() {
    if [[ -f "${path_to_picket_database}"/apps.db/apps ]] ; then
        rm "${path_to_picket_database}/apps.db/apps"
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/app1 ]] ; then
        rm "${path_to_picket_database}/apps.db/app0"
    fi
}

delete_unused_app() {
    if [[ -f "${path_to_picket_database}"/sites.db/sites ]] ; then
        rm "${path_to_picket_database}"/sites.db/sites
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/apps ]] ; then
        rm "${path_to_picket_database}/apps.db/apps"
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/app0 ]] ; then
        rm "${path_to_picket_database}/apps.db/app0"
    fi
}

list_apps__one_app(){
    if [[ -f "${path_to_picket_database}"/apps.db/apps ]] ; then
        rm "${path_to_picket_database}/apps.db/apps"
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/app0 ]] ; then
        rm "${path_to_picket_database}/apps.db/app0"
    fi
}

list_apps__two_apps() {
    if [[ -f "${path_to_picket_database}"/apps.db/apps ]] ; then
        rm "${path_to_picket_database}/apps.db/apps"
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/app0 ]] ; then
        rm "${path_to_picket_database}/apps.db/app0"
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/app1 ]] ; then
        rm "${path_to_picket_database}/apps.db/app1"
    fi
}

list_apps__one_app_for_site() {
    if [[ -f "${path_to_picket_database}"/sites.db/sites ]] ; then
        rm "${path_to_picket_database}"/sites.db/sites
    fi
    if [[ -f "${path_to_picket_database}"/sites.db/site0 ]] ; then
        rm "${path_to_picket_database}"/sites.db/site0
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/apps ]] ; then
        rm "${path_to_picket_database}/apps.db/apps"
    fi
    if [[ -f "${path_to_picket_database}"/apps.db/app0 ]] ; then
        rm "${path_to_picket_database}/apps.db/app0"
    fi
}

case "$test_case" in
    ("command stage, valid site argument; user file too big") command_stage__no_arguments__user_file_too_big;;
    ("command logout, no arguments; no user logged in") command_logout__no_arguments__no_user_logged_in;;
    ("command logout, no arguments; user logged in") command_logout__no_arguments__user_logged_in;;
    ("command deploy, user not logged in, valid site argument") command_deploy__user_not_logged_in__valid_site_argument;;
    ("valid site id") valid_site_id;;
    ("create site") create_site;;
    ("list sites, one site") list_sites__one_site;;
    ("list sites, two sites") list_sites__two_sites;;
    ("create app") create_app;;
    ("create app valid app ID") create_app_valid_app_ID;;
    ("update app") update_app;;
    ("delete unused app") delete_unused_app;;
    ("get app project root from ID") get_app_project_root_from_ID;;
    ("list apps, one app") list_apps__one_app;;
    ("list apps, two apps") list_apps__two_apps;;
    ("list apps, one app for site") list_apps__one_app_for_site;;
esac

exit 0
