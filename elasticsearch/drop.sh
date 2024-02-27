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

# Get all index names, excluding system indices
indices=$(curl -u "$USERNAME:$PASSWORD" -s "$HOST/_cat/indices?h=index" | grep -v -E "^\.")

echo $indices

# Loop over the indices and delete them
for index in $indices; do
    echo "Deleting index: $index"
    curl -u "$USERNAME:$PASSWORD" -X DELETE "$HOST/$index"
    echo "" # New line for cleaner output
done

echo "All non-system indices have been deleted."