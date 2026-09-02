#!/bin/bash
# sets up usage
USAGE="usage: $0 deploy | undeploy | stage | unstage | delete | help | -s|--siteId siteId | -u|--userId userId --ip ipAddress -c|--incremental -d|--debug --help"

#set up defaults
incremental=0

picket_command=help

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(create-site) picket_command=create-site;;
		(list-sites) picket_command=list-sites;;
		(deploy) picket_command=deploy;;
		(undeploy) picket_command=undeploy;;
		(stage) picket_command=stage;;
		(unstage) picket_command=unstage;;
		(delete) picket_command=delete;;
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
        (-u) userId="$2"; shift;;
        (--userId) userId="$2"; shift;;
        (--ip) ipAddress="$2"; shift;;
		(-c) incremental=1;;
		(--incremental) incremental=1;;
        (-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

argument_value_incremental=""
if [[ $incremental -eq 1 ]] ; then
    argument_value_incremental="--incremental"
fi

argument_value_debug=""
if [[ $DEBUG -eq 1 ]] ; then
    argument_value_debug="--debug"
fi

case "${picket_command}" in
    (create-site)
        picket-create-site --siteId "${siteId}" $argument_value_debug
    ;;
    (list-sites)
        picket-list-sites $argument_value_debug
    ;;
    (deploy)
        if [[ ! -n "${siteId}" ]] ; then
            echo "You did not select a site. Use ''picket deploy --siteId wxyz'' to choose a site to deploy."
            exit 1
        fi
        if [[ ! -n "${userId}" ]] ; then
            echo "You did not provide a user ID. Use ''picket deploy --siteId ... --userId your_name --ip 192.0.2.0'', or type ''picket login your_name'' to log in permanently."
            exit 1
        fi
        if [[ ! -n "${ipAddress}" ]] ; then
            echo "You did not provide an IP address. Use ''picket deploy --siteId ... --userId your_name --ip 192.0.2.0'', or type ''picket login your_name'' to log in permanently."
            exit 1
        fi
        picket-deploy-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress $argument_value_incremental $argument_value_debug
    ;;
    (undeploy)
        if [[ ! -n "${siteId}" ]] ; then
            echo "You did not select a site. Use ''picket undeploy --siteId wxyz'' to choose a site to undeploy."
            exit 1
        fi
        if [[ ! -n "${userId}" ]] ; then
            echo "User ID \'${userId}\' is not valid. Exiting."
            exit 1
        fi
        if [[ ! -n "${ipAddress}" ]] ; then
            echo "IP address \'${ipAddress}\' is not valid. Exiting."
            exit 1
        fi
        picket-undeploy-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress $argument_value_debug
    ;;
    (stage)
        picket-stage-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress $argument_value_incremental $argument_value_debug
    ;;
    (unstage)
        picket-unstage-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress $argument_value_debug
    ;;
    (delete)
        picket-delete-site --siteId "${siteId}" $argument_value_debug
    ;;
    (help)
        echo ${USAGE}
    ;;
    (-*)
        echo >&2 ${USAGE}
        exit 1
    ;;
esac
exit 0
