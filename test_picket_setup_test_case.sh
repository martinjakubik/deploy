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

valid_site_id() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    if [[ ! -d "${path_to_picket_database}/sites.db" ]] ; then
        mkdir -p "${path_to_picket_database}/sites.db"
    fi
    echo "siteId=site0" > "${path_to_picket_database}/sites.db/sites"
    touch "${path_to_picket_database}/sites.db/site0"
}

create_site() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
}

list_sites__one_site() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    if [[ ! -d "${path_to_picket_database}/sites.db" ]] ; then
        mkdir -p "${path_to_picket_database}/sites.db"
    fi
    echo "siteId=site0" > "${path_to_picket_database}/sites.db/sites"
    echo "path=site0" > "${path_to_picket_database}/sites.db/site0"
}

list_sites__two_sites() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    if [[ ! -d "${path_to_picket_database}/sites.db" ]] ; then
        mkdir -p "${path_to_picket_database}/sites.db"
    fi
    echo "siteId=site0" > "${path_to_picket_database}/sites.db/sites"
    echo "siteId=site1" >> "${path_to_picket_database}/sites.db/sites"
    echo "path=site0" > "${path_to_picket_database}/sites.db/site0"
    echo "path=site1" > "${path_to_picket_database}/sites.db/site1"
}

create_app() {
    :
}

update_app() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    if [[ ! -d "${path_to_picket_database}/sites.db" ]] ; then
        mkdir -p "${path_to_picket_database}/sites.db"
    fi
    if [[ ! -d "${path_to_picket_database}/apps.db" ]] ; then
        mkdir -p "${path_to_picket_database}/apps.db"
    fi
    echo "siteId=site0" > "${path_to_picket_database}/sites.db/sites"
    echo "appId=app0" > "${path_to_picket_database}/sites.db/site0"
    echo "appId=app0" > "${path_to_picket_database}/apps.db/apps"
    echo "path=app0" > "${path_to_picket_database}/apps.db/app0"
    # makes the app0 source code if it does not exist
    all_project_root=~/code/gitwork
    if [[ ! -d "${all_project_root}/app0" ]] ; then
        mkdir -p "${all_project_root}/app0"
    fi
    if [[ ! -d "${all_project_root}/app0/app" ]] ; then
        mkdir p "${all_project_root}/app0/app"
    fi
    if [[ ! -f "${all_project_root}/app0/app0-custom-source-code-files" ]] ; then
        touch "${all_project_root}/app0/app0-custom-source-code-files"
    fi
    if [[ ! -f "${all_project_root}/app0/app0-custom-binary-files" ]] ; then
        touch "${all_project_root}/app0/app0-custom-binary-files"
    fi
    if [[ ! -f "${all_project_root}/app0/app/logo.png" ]] ; then
        touch "${all_project_root}/app0/app/logo.png"
    fi
}

get_app_project_root_from_ID() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    if [[ ! -d "${path_to_picket_database}/apps.db" ]] ; then
        mkdir -p "${path_to_picket_database}/apps.db"
    fi
    echo "appId=app0" > "${path_to_picket_database}/apps.db/apps"
    echo "path=app0" > "${path_to_picket_database}/apps.db/app0"
}

delete_unused_app() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    if [[ ! -d "${path_to_picket_database}/sites.db" ]] ; then
        mkdir -p "${path_to_picket_database}/sites.db"
    fi
    if [[ ! -d "${path_to_picket_database}/apps.db" ]] ; then
        mkdir -p "${path_to_picket_database}/apps.db"
    fi
    touch "${path_to_picket_database}/sites.db/sites"
    echo "appId=app0" > "${path_to_picket_database}/apps.db/apps"
    echo "path=app0" > "${path_to_picket_database}/apps.db/app0"
}

list_apps__one_app() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    if [[ ! -d "${path_to_picket_database}/apps.db" ]] ; then
        mkdir -p "${path_to_picket_database}/apps.db"
    fi
    echo "appId=app0" > "${path_to_picket_database}/apps.db/apps"
    echo "path=app0" > "${path_to_picket_database}/apps.db/app0"
}

list_apps__two_apps() {
    if [[ ! -d "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
    if [[ ! -d "${path_to_picket_database}/apps.db" ]] ; then
        mkdir -p "${path_to_picket_database}/apps.db"
    fi
    echo "appId=app0" > "${path_to_picket_database}/apps.db/apps"
    echo "appId=app1" >> "${path_to_picket_database}/apps.db/apps"
    echo "path=app0" > "${path_to_picket_database}/apps.db/app0"
    echo "path=app1" > "${path_to_picket_database}/apps.db/app1"
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
    ("update app") update_app;;
    ("delete unused app") delete_unused_app;;
    ("get app project root from ID") get_app_project_root_from_ID;;
    ("list apps, one app") list_apps__one_app;;
    ("list apps, two apps") list_apps__two_apps;;
esac

exit 0
