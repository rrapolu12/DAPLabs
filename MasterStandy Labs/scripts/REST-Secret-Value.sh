#!/bin/bash
#
# Script Purpose:
# 	- Authenticate to Conjur/DAP REST API
#	- This demonstration will showcase how to create a new secret/variable
#

# Global Variables
dapURL=dap-master.cyber-ark-demo.local

# Prompt user for Conjur/DAP User
read -p "Enter DAP Admin User: " dap_user
read -p "Enter Password: " -s dap_pass
echo " "
read -p "Enter DAP Account (CAU): " account

# Prompt for Variable Information
echo " "
echo "Now enter the secret information:"
echo " "
read -p "Enter Secret ID: " secret_id
read -p "Enter Secret Value: " -s secret_value
echo " "
echo " "

# Obtain user API key 
cred_base64=$(echo -n $dap_user:$dap_pass | base64)
api_key=$(curl -s -k --header "Authorization: Basic $cred_base64" "https://$dapURL/authn/$account/login")

# Obtain Conjur/DAP Users temporary access token
# Store the temporary access token data to temporary variable
response=$(curl -s -k --request POST --header "Content-Type: text/plain" --data-binary "$api_key" "https://$dapURL/authn/$account/$dap_user/authenticate")

# Encode the temporary access token for use
token=$(echo -n $response | base64 | tr -d '\r\n')

# Connect to the Conjur/DAP REST API to add/update secret value"
echo "---- Adding / Updating Secret Value ----"
echo "ID: $secret_id"
echo "Value: $secret_value"
echo "----------------------------------------"
curl -s -k --request POST --header "Authorization: Token token=\"$token\"" --data "$secret_value" "https://$dapURL/secrets/$account/variable/$secret_id"
echo " "

