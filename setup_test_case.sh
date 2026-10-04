#!/bin/bash

test_case="$1"
echo case "$test_case"

if [[ "$2" = "--configuration-file" ]] ; then
    configuration_file_argument="$3"
fi

picket_configuration_file="/etc/picket/config.picket"
if [[ -f "$HOME/config/picket/config.picket" ]] ; then
    picket_configuration_file="$HOME/config/picket/config.picket"
fi
if [[ -n "${configuration_file_argument}" && -f "${configuration_file_argument}" ]] ; then
    picket_configuration_file="${configuration_file_argument}"
fi

read_picket_configuration() {
    configuration_array=()

    finished_reading_file=false
    until $finished_reading_file; do
        read -r || finished_reading_file=true
        line="${REPLY}"

        # skips comments and empty lines
        if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "$line" ]]; then
          continue
        fi

        # parses key-value pairs
        if [[ "$line" =~ ^[[:space:]]*([^=]+)=(.*)$ ]]; then
            key="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"

            # trims whitespace from key and value
            key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            configuration_array+=("$key=$value")
        fi
    done < "${picket_configuration_file}"

    # reads values from config
    path_to_site_database=""
    path_to_picket_database=""
    for entry in "${configuration_array[@]}"; do
        case "$entry" in
            (path_to_picket_database=*)
                path_to_picket_database_value="${entry#path_to_picket_database=}"
                path_to_picket_database="${path_to_picket_database_value/\$HOME/$HOME}"
                export path_to_picket_database ;;
            (path_to_site_database=*)
                path_to_site_database_value="${entry#path_to_site_database=}"
                path_to_site_database="${path_to_site_database/\$HOME/$HOME}"
                export path_to_site_database ;;
        esac
    done
}

read_picket_configuration

command_stage__no_arguments__user_file_too_big() {
    echo -n > "${path_to_picket_database}"/user
    for (( i=0 ; i < 128 ; i=i+1 )) ; do
        echo -n 0 >> "${path_to_picket_database}"/user
    done
}

command_logout__no_arguments__no_user_logged_in() {
    echo -n > "${path_to_picket_database}"/user
}

command_logout__no_arguments__user_logged_in() {
    echo -n "test_user_id" > "${path_to_picket_database}"/user
}

case "$test_case" in
    ("command stage, valid site argument; user file too big") command_stage__no_arguments__user_file_too_big;;
    ("command logout, no arguments; no user logged in") command_logout__no_arguments__no_user_logged_in;;
    ("command logout, no arguments; user logged in") command_logout__no_arguments__user_logged_in;;
esac

exit 0
