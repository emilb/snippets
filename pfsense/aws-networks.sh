#!/bin/bash

# Usage:
# aws-networks.sh
#
# Downloads the list of AWS networks and outputs
# alias defintion in XML for pfsense config.
#

which jq &> /dev/null || { printf 'Missing required jq\n'; exit 1; }
which wget &> /dev/null || { printf 'Missing required wget\n'; exit 1; }

wget https://ip-ranges.amazonaws.com/ip-ranges.json

regions=`cat ip-ranges.json | jq -r '.prefixes[] .region' | sort -u`

for region in $regions
do
	regions_safename=`echo "$region" | tr - _`

	networks=`cat ip-ranges.json | jq -r '.prefixes[] | select(.region=="'$region'") | .ip_prefix'`

	networks_joined=""
 	for network in $networks
 	do
 		networks_joined="$networks_joined $network"
 	done

 	# Remove trailing spaces
 	read  -rd '' networks_joined <<< "$networks_joined"

 	gen_time=`date`

	cat << EOF
<alias>
	<name>AWS_$regions_safename</name>
	<address>$networks_joined</address>
	<descr><![CDATA[AWS $region networks]]></descr>
	<type>network</type>
	<detail><![CDATA[Generated on $gen_time]]></detail>
</alias>
EOF

done
