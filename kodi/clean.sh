#!/bin/bash

# Usage:
# clean.sh <ip>
#
# Cleans the library for the Kodi running at <ip>
#

which curl &> /dev/null || { printf 'Missing required curl\n'; exit 1; }

xbmcAddress=$1

curl -s --data-binary '{ "id": 1, "jsonrpc": "2.0", "method": "VideoLibrary.Clean" }' -H 'content-type: application/json;' http://$xbmcAddress:80/jsonrpc | jq '.'

#curl -s --data-binary '{ "id": 1, "jsonrpc": "2.0", "method": "Addons.GetAddons" }' -H 'content-type: application/json;' http://$xbmcAddress:80/jsonrpc | jq '.'
