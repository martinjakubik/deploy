#!/bin/bash
# sets up usage
USAGE="usage: $0 deploy | undeploy | delete -s|--siteId siteId | help"

#set up defaults
incremental=0

picket_command=help

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
		(deploy) picket_command=deploy;;
		(undeploy) picket_command=undeploy;;
		(delete) picket_command=delete;;
		(-s) siteId="$2"; shift;;
        (--siteId) siteId="$2"; shift;;
		(-c) incremental=1;;
		(--incremental) incremental=1;;
		(-*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

case "${picket_command}" in
    (deploy)
        picket-deploy-site --siteId "${siteId}"
    ;;
    (undeploy)
        echo picket-undeploy-site --siteId "${siteId}"
    ;;
    (delete)
        echo picket-delete-site --siteId "${siteId}"
    ;;
    (-*)
        echo >&2 ${USAGE}
        exit 1
    ;;
esac
