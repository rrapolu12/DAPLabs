#!/bin/bash

# GENERATE: Basic Script to generate a SSL certificate CSR request for DAP Follower Server

# Global Variables
serverType="follower"
country="US"
state="MA"
city="Boston"
organization="CyberArk"
commonName=dap-"follower1.cyber-ark-demo.local"

# Generate SSL Key
sudo openssl genrsa -out dap-$serverType.key 2048

# Generate SSL CSR Request
sudo openssl req -new -sha256 -key dap-$serverType.key -subj "/C=$country/ST=$state/L=$city/O=$organization/CN=$commonName" -reqexts SAN$serverType -config dap-openssl.cnf -out dap-$serverType.csr

# View SSL CSR Request Output
cat dap-$serverType.csr
