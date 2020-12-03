#!/bin/bash

# IMPORT: Basic Script to import SSL certificate for DAP Master Server

# Global Variables
certDir="/home/user01/DAPLabs/certs"
masterContainer="dap1"
archive="certBundle.tar"

# Change working directory
cd $certDir

# Create archive file for SSL certificates
tar -cf $archive cacert.cer dap-follower.key dap-follower.cer dap-master.key dap-master.cer

# Import SSL certificates to DAP Master Server
docker cp $archive $masterContainer:/tmp/
docker exec $masterContainer tar -xf /tmp/$archive
docker exec $masterContainer evoke ca import --force --root cacert.cer
docker exec $masterContainer evoke ca import --key dap-follower.key dap-follower.cer
docker exec $masterContainer evoke ca import --key dap-master.key --set dap-master.cer
