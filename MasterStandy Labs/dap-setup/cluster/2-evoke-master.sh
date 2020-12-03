#!/bin/bash

# CONFIGURE: Basic Script to configure DAP container as Master Server (dap1)

# Global Variables
masterContainer="dap1"
serverType="master"
masterDNS="dap1.cyber-ark-demo.local"
clusterDNS="dap-master.cyber-ark-demo.local"
standby1DNS="dap2.cyber-ark-demo.local"
standby2DNS="dap3.cyber-ark-demo.local"
adminPass="Mypassw0rD1!"
accountName="CAU"

# EVOKE: Execute evoke command to configure DAP container as Master Server
docker exec $masterContainer evoke configure $serverType --accept-eula -h $masterDNS --master-altnames "$clusterDNS,$standby1DNS,$standby2DNS" -p $adminPass $accountName
