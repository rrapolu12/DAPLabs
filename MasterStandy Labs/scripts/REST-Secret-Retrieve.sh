#!/bin/bash
#
# Script Purpose:
# 	- Authenticate to Conjur/DAP REST API
#	- Retrieve a secret value
#

# Global Variables
dapURL=dap-master.cyber-ark-demo.local

# Prompt user for Conjur/DAP User
read -p "Enter DAP User: " dap_user
read -p "Enter Password: " -s dap_pass
echo " "
read -p "Enter DAP Account (CAU): " account

# Prompt Secret ID to Retrieve
echo " "
echo "Enter variable ID to retrieve"
echo "   - Must include REST API friendly URL"
echo " "
echo "Query Escape Values:"
echo "   : --> %3A    / --> %2F"
echo " "
echo "Examples:" 
echo '   somevariable --> somevariable' 
echo '   dev/app/db/mysql/cars/cardbapp/password --> dev%2Fapp%2Fdb%2Fmysql%2Fcars%2Fcardbapp%2Fpassword'
echo " "
read -p "Enter Variable ID: " secret_id
read -p "Specify Version (y/n): " cond_check

# Obtain user API key 
cred_base64=$(echo -n $dap_user:$dap_pass | base64)
api_key=$(curl -s -k --header "Authorization: Basic $cred_base64" "https://$dapURL/authn/$account/login")

# Obtain Conjur/DAP Users temporary access token
# Store the temporary access token data to temporary variable
response=$(curl -s -k --request POST --header "Content-Type: text/plain" --data-binary "$api_key" "https://$dapURL/authn/$account/$dap_user/authenticate")

# Encode the temporary access token for use
token=$(echo -n $response | base64 | tr -d '\r\n')

# Check Condition - retrieve current version or user specified?
if [ $cond_check = "y" ]; then
  read -p "Enter Version Number: " version
  # Connect to the Conjur/DAP REST API to retrieve secret value"
  secret_value=$(curl -s -k --header "Authorization: Token token=\"$token\"" "https://$dapURL/secrets/$account/variable/$secret_id?version=$version")
  echo " "
  echo "---- Retrieving Secret Value -----------"
  echo "ID: $secret_id"
  echo "Value: $secret_value"
  echo "----------------------------------------"
  echo " "
else
  # Connect to the Conjur/DAP REST API to retrieve secret value"
  secret_value=$(curl -s -k --header "Authorization: Token token=\"$token\"" "https://$dapURL/secrets/$account/variable/$secret_id")
  echo " "
  echo "---- Retrieving Secret Value -----------"
  echo "ID: $secret_id"
  echo "Value: $secret_value"
  echo "----------------------------------------"
  echo " "
fi
