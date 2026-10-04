#!/bin/bash
# sets up usage
USAGE="usage: $0 -d|--debug"

# set up defaults
DEBUG=0
configuration_file_argument=""

# parses and reads command line arguments
while [ $# -gt 0 ]
do
	case "$1" in
    	(--configuration-file) configuration_file_argument="$2"; shift;;
		(-d) DEBUG=1;;
        (--debug) DEBUG=1;;
		(*) echo >&2 ${USAGE}
		exit 1;;
	esac
		shift
done

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

is_valid_picket_database=$(picket-function-is-valid-path-to-picket-database "${path_to_picket_database}")

if [[ $is_valid_picket_database -eq 1 ]] ; then
    if [[ ! -e "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
else
    echo "The picket database path is invalid. Add the line \"path_to_picket_database=$HOME/.picket\" to your \"$HOME/config/picket/config.picket\" file."
    exit 1
fi

if [[ -f "${path_to_picket_database}"/user && $(wc -c < "${path_to_picket_database}"/user) -gt 0 ]] ; then
    echo "[ Logging out. ]"
    rm "${path_to_picket_database}"/user
else
    echo "There is no user logged in."
    exit 1
fi
exit 0
