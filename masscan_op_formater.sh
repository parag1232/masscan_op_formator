#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "Error: jq is not installed. Please install it and try again."
    exit 1
fi

# Check for input JSON file
if [[ ! -f $1 ]]; then
    echo "Usage: $0 <path_to_json_file>"
    exit 1
fi

# Process the JSON and generate the URLs
cat $1 | jq 'group_by(.ip) | map({"ip": .[0].ip, "timestamp": map(.timestamp), "ports": map(.ports[0])})' | jq -r '.[] | .ip as $ip | .ports[] | "http://\($ip):\(.port)", "https://\($ip):\(.port)"'