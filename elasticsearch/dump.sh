#!/bin/bash

# Elasticsearch credentials
USERNAME="elastic"
PASSWORD="changeme"

# Elasticsearch host
HOST="localhost:9200"

# Directory to save the mappings
OUTPUT_DIR="./.current_indexes"

# Ensure the directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
  mkdir -p "$OUTPUT_DIR"
fi

# Array of index names to process
# declare -a INDEXES=("rsquared-2023-12" "rsquared-2024-01" "rsquared-2024-02")
declare -a INDEXES=("search-rsquared-2023-12")

# Loop through each index
for INDEX in "${INDEXES[@]}"; do
  # Target file to save the mappings, incorporating the index name dynamically
  OUTPUT_FILE="$OUTPUT_DIR/mappings_$INDEX.json"

  # Perform the curl operation to get mappings and parse the output with jq
  curl -u "$USERNAME:$PASSWORD" -X GET "$HOST/$INDEX/_mapping" | jq . > "$OUTPUT_FILE"

  echo "Mappings saved to $OUTPUT_FILE"
done