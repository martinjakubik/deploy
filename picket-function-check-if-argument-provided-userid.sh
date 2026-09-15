if [[ ! -n "${1}" ]] ; then
    echo "You did not provide a user ID. Use ''picket login --userId your_name'' to log in permanently."
    exit 1
fi

exit 0
