appId="$1"

if [[ $(picket-function-is-valid-app-id "${appId}") -ne 1 ]] ; then
    echo "invalid app ID"
    exit 1
fi

picket_configuration_file="/etc/picket/config.picket"
if [[ -f "$HOME/.config/picket/config.picket" ]] ; then
    picket_configuration_file="$HOME/.config/picket/config.picket"
fi
if [[ -n "${picket_path_to_configuration_file}" && -f "${picket_path_to_configuration_file}" ]] ; then
    picket_configuration_file="${picket_path_to_configuration_file}"
fi

source picket-function-read-configuration "${picket_configuration_file}"

if [[ -z "${path_to_picket_database}" ]] ; then
    echo "There is no database configured for picket. Add the line \"path_to_picket_database=$HOME/.picket\" to your \"$HOME/config/picket/config.picket\" file."
    exit 1
fi

is_valid_picket_database=$(picket-function-is-valid-path-to-picket-database "${path_to_picket_database}")

if [[ $is_valid_picket_database -eq 1 ]] ; then
    if [[ ! -e "${path_to_picket_database}" ]] ; then
        mkdir -p "${path_to_picket_database}"
    fi
else
    echo "The picket database path is invalid. Add the line \"path_to_picket_database=$HOME/.picket\" to your \"$HOME/config/picket/config.picket\" file."
    exit 1
fi

picket_app_configuration_file="${path_to_picket_database}/apps.db/${appId}"

app_configuration_array=()

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
        app_configuration_array+=("$key=$value")
    fi
done < "${picket_app_configuration_file}"

# reads values from config
path_to_app=""
for entry in "${app_configuration_array[@]}"; do
    case "$entry" in
        (path=*)
            path_to_app_value="${entry#path=}"
            path_to_app="${path_to_app_value/\$HOME/$HOME}"
            echo "${path_to_app}"
            exit 0 ;;
    esac
done
