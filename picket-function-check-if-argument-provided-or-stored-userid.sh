userId="${1}"
if [[ ! -n "${userId}" ]] ; then
    if [[ -f ~/.picket/user ]] ; then
        filesize=$(wc -c < ~/.picket/user)
        if [[ $filesize -gt 127 ]] ; then
            echo "There is a problem with the user record. Use ''picket login --userId your_name'' to log in again."
            exit 1
        fi
        read -r < ~/.picket/user
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
