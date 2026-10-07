userId="${1}"

picket_configuration_file="/etc/picket/config.picket"
if [[ -f "$HOME/.config/picket/config.picket" ]] ; then
    picket_configuration_file="$HOME/.config/picket/config.picket"
fi
if [[ -n "${picket_path_to_configuration_file}" && -f "${picket_path_to_configuration_file}" ]] ; then
    picket_configuration_file="${picket_path_to_configuration_file}"
fi

source picket-function-read-configuration "${picket_configuration_file}"

if [[ ! -n "${userId}" ]] ; then
    if [[ -f "${path_to_picket_database}"/user ]] ; then
        filesize=$(wc -c < "${path_to_picket_database}"/user)
        if [[ $filesize -gt 127 ]] ; then
            echo "There is a problem with the user record. Use ''picket login --userId your_name'' to log in again."
            exit 1
        fi
        read -r < "${path_to_picket_database}"/user
        user_file_content="$REPLY"
        userId="$user_file_content"

        if [[ ! -n "$user_file_content" ]] ; then
            echo "You did not provide a user ID. Use ''picket <command> --siteId ... --userId your_name --ip 192.0.2.0'', or type ''picket login your_name'' to log in permanently."
            exit 1
        fi
    else
        echo "You did not provide a user ID. Use ''picket <command> --siteId ... --userId your_name --ip 192.0.2.0'', or type ''picket login your_name'' to log in permanently."
        exit 1
    fi
fi

exit 0
