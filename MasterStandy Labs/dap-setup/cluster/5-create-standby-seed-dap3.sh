#!/bin/bash

# CREATE: Basic Script to create Seed Archive File from DAP Master for Standby Server (dap3)

# Global Variables
serverType="standby"
standbyContainer="dap3"
standbyDNS="dap3.cyber-ark-demo.local"
masterContainer="dap1"
masterDNS="dap1.cyber-ark-demo.local"
dockerHost2Username="user01"
dockerHost2IP="10.0.0.20"
dockerHost2Dir="/home/user01/DAPLabs/dap-setup"

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

# Copy Seed Archive to Docker Host (docker-host2)
echo "Copy seed archive to Docker Host: docker-host2"
echo "------------------------------------"
set -x
scp $serverType-$standbyContainer-seed.tar $dockerHost2Username@$dockerHost2IP:$dockerHost2Dir
set +x
