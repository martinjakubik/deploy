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
    (deploy)
        picket-deploy-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress
    ;;
    (undeploy)
        picket-undeploy-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress
    ;;
    (stage)
        picket-stage-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress $argument_value_incremental $argument_value_debug
    ;;
    (unstage)
        picket-unstage-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress
    ;;
    (delete)
        picket-delete-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress
    ;;
    (-*)
        echo >&2 ${USAGE}
        exit 1
    ;;
esac
