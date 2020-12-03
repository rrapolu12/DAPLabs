#!/bin/bash

# INSTALL: Basic Script to install DAP Standby Server (dap2)

# Global Variables
serverType="standby"
standbyContainer="dap2"
standbyDNS="dap2.cyber-ark-demo.local"
standbyIP="10.0.0.101"
masterContainer="dap1"
masterDNS="dap1.cyber-ark-demo.local"
version="11.4.0"		## Change to installation version


# Create Seed Archive File
echo "Creating seed archive: $standbyDNS"
echo "------------------------------------"
set -x
docker exec -t $masterContainer bash -c "evoke seed $serverType $standbyDNS > /tmp/$serverType-$standbyContainer-seed.tar"
set +x

# Copy Seed Archive to Docker Host (docker-host1)
echo "Copy seed archive to Docker Host: docker-host1"
echo "------------------------------------"
set -x
docker cp $masterContainer:/tmp/$serverType-$standbyContainer-seed.tar .
set +x

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
docker cp $serverType-$standbyContainer-seed.tar $standbyContainer:/tmp
set +x

# Unpack the seed archive
echo "Unpack seed archive file"
echo "------------------------------------"
set -x
docker exec -it $standbyContainer bash -c "evoke unpack seed /tmp/$serverType-$standbyContainer-seed.tar"
set +x

# Install & Configure Server
echo "Install & Configure Server: $standbyDNS"
echo "------------------------------------"
set -x
docker exec -it $standbyContainer bash -c "evoke configure $serverType --master-address=$masterDNS"
set +x
