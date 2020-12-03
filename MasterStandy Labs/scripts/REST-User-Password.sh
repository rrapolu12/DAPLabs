#!/bin/bash
#
# Script Purpose:
# 	- Authenticate to Conjur/DAP REST API
#	- This demonstration will showcase how to change a User password
#

# Global Variables
dapURL=dap-master.cyber-ark-demo.local

# Prompt user for Conjur/DAP User
read -p "Enter DAP User: " dap_user
read -p "Enter Password: " -s dap_pass
echo " "
read -p "Enter DAP Account (CAU): " account

# Prompt for Variable Information
echo " "
echo "Now enter the new password information:"
echo " "
read -p "Enter New Password: " -s new_pass
echo " "
echo " "

# Connect to the Conjur/DAP REST API to change the User password"
echo "---- Updating User Password ------------"
echo "User ID: $dap_user"
echo "----------------------------------------"
curl -s -k --request PUT --data "$new_pass" --user $dap_user:$dap_pass "https://$dapURL/authn/$account/password"
echo " "

