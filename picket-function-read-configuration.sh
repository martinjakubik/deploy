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

echo ${configuration_array[@]}
