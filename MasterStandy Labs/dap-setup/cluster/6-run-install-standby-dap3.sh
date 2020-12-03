#!/bin/bash

# RUN: Basic Script to launch install of remote DAP Standby Server (dap3)

# Global Variables
dockerHost2Username="user01"
dockerHost2IP="10.0.0.20"
dockerHost2Dir="/home/user01/DAPLabs/dap-setup"
dockerHost2Script="6-install-standby-dap3.sh"

# Run DAP Standby Server Install Script Remotely on Docker Host (docker-host2)
echo "Run DAP Standby Server Install on Docker Host (docker-host2)"
echo "Remote Script: $dockerHost2Dir/$dockerHost2Script"
echo "------------------------------------"
set -x
ssh -l $dockerHost2Username $dockerHost2IP $dockerHost2Dir/$dockerHost2Script
set +x
