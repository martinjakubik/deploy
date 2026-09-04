if [[ ! -n "${1}" ]] ; then
    echo "You did not select a site. Use ''picket <command> --siteId wxyz'' to choose a site to work with."
    exit 1
fi
