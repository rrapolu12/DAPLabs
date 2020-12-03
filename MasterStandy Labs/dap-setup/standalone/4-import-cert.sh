#!/bin/bash

# IMPORT: Basic Script to import SSL certificate for DAP Master Server

# Global Variables
masterContainer="dap-standalone"
archive="certBundle.tar"

# Create archive file for SSL certificates
tar -cf $archive cacert.cer $masterContainer.key $masterContainer.cer

# Import SSL certificates to DAP Master Server
sudo docker cp $archive $masterContainer:/tmp/
sudo docker exec $masterContainer tar -xf /tmp/$archive
sudo docker exec $masterContainer evoke ca import --force --root cacert.cer
sudo docker exec $masterContainer evoke ca import --key $masterContainer.key --set $masterContainer.cer
