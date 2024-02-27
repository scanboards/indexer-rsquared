#!/bin/bash

# Default values
USERNAME="elastic"
PASSWORD="changeme"
HOST="localhost:9200"

# Override with env variables if they exist
[ -n "$ES_USERNAME" ] && USERNAME=$ES_USERNAME
[ -n "$ES_PASSWORD" ] && PASSWORD=$ES_PASSWORD
[ -n "$ES_HOST" ] && HOST=$ES_HOST

# echo "Using Elasticsearch credentials:"
# echo "Username: $USERNAME"
# echo "Password: $PASSWORD"
# echo "Host: $HOST"

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Path to the mappings file relative to the script's location
MAPPINGS_FILE="$SCRIPT_DIR/mappings.json"

# Check if the mappings file exists
if [ ! -f "$MAPPINGS_FILE" ]; then
    echo "Mappings file $MAPPINGS_FILE does not exist."
    exit 1
fi

echo $MAPPINGS_FILE

# Load the mapping JSON from the mappings file
MAPPING_JSON=$(cat "$MAPPINGS_FILE")

# Starting year
START_YEAR=2023

# Number of years to process
YEARS=7

# Generate indices for each year and month
for (( YEAR=START_YEAR; YEAR<START_YEAR+YEARS; YEAR++ )); do
    for (( MONTH=1; MONTH<=12; MONTH++ )); do
        # Use printf to ensure the month is zero-padded
        FORMATTED_MONTH=$(printf "%02d" $MONTH)

        INDEX_NAME="search-rsquared-${YEAR}-${FORMATTED_MONTH}"

        echo "Processing $INDEX_NAME..."
        curl -u "$USERNAME:$PASSWORD" -X PUT "$HOST/$INDEX_NAME" \
             -H 'Content-Type: application/json' \
             -d"$MAPPING_JSON"
    done
done