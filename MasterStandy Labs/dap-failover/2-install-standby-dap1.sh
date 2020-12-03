#!/bin/bash

# INSTALL: Basic Script to install DAP Standby Server (dap1)

# Global Variables
serverType="standby"
standbyContainer="dap1"
standbyDNS="dap1.cyber-ark-demo.local"
standbyIP="10.0.0.100"
masterContainer="dap3"
masterDNS="dap3.cyber-ark-demo.local"
dockerHost1Dir="/home/user01/DAPLabs/dap-failover"
version="11.2.1"		## Change to installation version

# Create Container (DAP Standby Server)
echo "Creating Docker Container: $standbyContainer"
echo "------------------------------------"
set -x
docker run --name $standbyContainer \
  -d --restart=always \
  --network conjur-ipvlan \
  --ip $standbyIP \
  --security-opt seccomp:unconfined \
  -v /var/log/conjur/$standbyContainer:/var/log/conjur/:Z \
  --log-driver json-file \
  --log-opt max-size=1000m \
  --log-opt max-file=3 \
  registry.tld/conjur-appliance:$version
set +x

# Copy Seed Archive to Server Container
echo "Copy seed archive to container: $standbyContainer"
echo "------------------------------------"
set -x
docker cp $dockerHost1Dir/$serverType-$standbyContainer-seed.tar $standbyContainer:/tmp
set +x

# Unpack the Seed Archive
echo "Unpack seed archive file"
echo "------------------------------------"
set -x
docker exec $standbyContainer bash -c "evoke unpack seed /tmp/$serverType-$standbyContainer-seed.tar"
set +x

# Install & Configure Server
echo "Install & Configure Server: $standbyDNS"
echo "------------------------------------"
set -x
docker exec $standbyContainer bash -c "evoke configure $serverType --master-address=$masterDNS"
set +x
