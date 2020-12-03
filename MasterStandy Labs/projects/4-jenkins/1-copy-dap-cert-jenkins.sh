#!/bin/bash

# COPY: Basic Script to copy SSL certificate of DAP Master to Jenkins Server

# Global Variables
masterContainer="dap1"
masterDNS="dap-master.cyber-ark-demo.local"
accountName="CAU"
dockerHost2Username="user01"
dockerHost2IP="10.0.0.20"
dockerHost2Dir="/home/user01"

# Export DAP Master SSL certificate conjur.pem 
echo "Exporting SSL Certificate from DAP Master"
echo "------------------------------------"
set -x
docker exec -t $masterContainer bash -c "openssl s_client -showcerts -connect $masterDNS:443 < /dev/null 2> /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /tmp/conjur-$accountName.pem"
set +x

# Copy DAP Master SSL Certificate to Docker-Host1
echo "Copy DAP Master SSL Certificate to Docker-Host1"
echo "------------------------------------"
set -x
docker cp $masterContainer:/tmp/conjur-$accountName.pem .
set +x

# Copy DAP Master SSL Certificate to Jenkins Server (docker-host2)
echo "Copy DAP Master SSL Certificate to Jenkins Server (docker-host2)"
echo "------------------------------------"
set -x
sudo scp conjur-$accountName.pem $dockerHost2Username@$dockerHost2IP:$dockerHost2Dir
set +x
