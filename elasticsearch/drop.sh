#!/bin/bash

# Elasticsearch credentials
USERNAME="elastic"
PASSWORD="changeme"

# Elasticsearch URL
ELASTICSEARCH_URL="http://localhost:9200"

# Get all index names, excluding system indices
indices=$(curl -u "$USERNAME:$PASSWORD" -s "$ELASTICSEARCH_URL/_cat/indices?h=index" | grep -v -E "^\.")

echo $indices

# Loop over the indices and delete them
for index in $indices; do
    echo "Deleting index: $index"
    curl -u "$USERNAME:$PASSWORD" -X DELETE "$ELASTICSEARCH_URL/$index"
    echo "" # New line for cleaner output
done

echo "All non-system indices have been deleted."