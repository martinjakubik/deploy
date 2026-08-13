#!/bin/bash
# sets up usage
USAGE="usage: $0 deploy | undeploy | stage | unstage | delete | help | -s|--siteId siteId | -u|--userId userId --ip ipAddress --help"

#set up defaults
incremental=0

picket_command=help

# parses and reads command line arguments
while [ $# -gt 0 ]
do
    echo parsing argument "$1"
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
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

case "${picket_command}" in
    (deploy)
        picket-deploy-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress
    ;;
    (undeploy)
        picket-undeploy-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress
    ;;
    (stage)
        picket-stage-site --siteId "${siteId}" --userId "${userId}" --ip $ipAddress
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
