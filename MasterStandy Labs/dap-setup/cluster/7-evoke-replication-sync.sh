#!/bin/bash

# EVOKE: Basic Script to configure DAP HA Cluster Server Replication

# Global Variables
masterContainer="dap1"
standby1Container="dap2"
standby2Container="dap3"
dockerHost2Username="user01"
dockerHost2IP="10.0.0.20"


# Run evoke replication sync enable on DAP Standby Servers (dap2, dap3)
echo "Run evoke replication sync enable to enable synchronous replication (dap2)"
echo "------------------------------------"
set -x
docker exec $standby1Container evoke replication sync enable
set +x
echo "Run evoke replication sync disable to enable asynchronous replication (dap3)"
echo "------------------------------------"
set -x
ssh -l $dockerHost2Username $dockerHost2IP docker exec $standby2Container evoke replication sync disable 
set +x

# Run evoke replication sync on DAP Master Server
echo "Run evoke replication sync start to start DAP HA Cluster Replication (dap1)"
echo "------------------------------------"
set -x
docker exec $masterContainer evoke replication sync start --force
set +x
