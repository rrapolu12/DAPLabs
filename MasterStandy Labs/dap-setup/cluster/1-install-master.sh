#!/bin/bash

# INSTALL: Basic Script to install DAP Master Server (dap1)

# Global Variables
masterContainer="dap1"
masterIP="10.0.0.100"
version="11.4.0"		## Change to installation version

# Create Docker Container
echo "Creating DAP Master Server Container"
echo "------------------------------------"
set -x
docker run --name $masterContainer \
  -d --restart=unless-stopped \
  --ip $masterIP \
  --network conjur-ipvlan \
  --security-opt seccomp:unconfined \
  -v /var/log/conjur/$masterContainer:/var/log/conjur/:Z \
  --log-driver json-file \
  --log-opt max-size=1000m \
  --log-opt max-file=3 \
  registry.tld/conjur-appliance:$version
set +x
