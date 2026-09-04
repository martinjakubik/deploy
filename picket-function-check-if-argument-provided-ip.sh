if [[ ! -n "${1}" ]] ; then
    echo "You did not provide an IP address. Use ''picket <command> --siteId ... --userId your_name --ip 192.0.2.0'', or type ''picket login your_name'' to log in permanently."
    exit 1
fi
