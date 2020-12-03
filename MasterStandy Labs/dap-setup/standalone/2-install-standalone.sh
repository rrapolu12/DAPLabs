#!/bin/bash

# INSTALL: Basic Script to install DAP Master Server

# Global Variables
masterContainer="dap-standalone"
masterIP="10.0.0.105"
version="11.2.1"		## Change to installation version

# Create Docker Container
echo "Creating DAP Master Server Container"
echo "------------------------------------"
set -x
docker run --name $masterContainer \
  -d --restart=always \
  --ip $masterIP \
  --network conjur-ipvlan \
  --security-opt seccomp:unconfined \
  -v /var/log/conjur/$masterContainer:/var/log/conjur/:Z \
  --log-driver json-file \
  --log-opt max-size=1000m \
  --log-opt max-file=3 \
  registry.tld/conjur-appliance:$version
set +x
