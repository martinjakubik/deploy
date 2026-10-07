picket_configuration_file="$1"

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
