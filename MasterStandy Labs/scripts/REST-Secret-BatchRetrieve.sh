#!/bin/bash
#
# Script Purpose:
# 	- Authenticate to Conjur/DAP REST API
#	- Batch retrieve multiple secret values
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
read -p "Enter 1st Variable ID: " variable_id1
read -p "Enter 2nd Variable ID: " variable_id2

# Obtain user API key 
cred_base64=$(echo -n $dap_user:$dap_pass | base64)
api_key=$(curl -s -k --header "Authorization: Basic $cred_base64" "https://$dapURL/authn/$account/login")

# Obtain Conjur/DAP Users temporary access token
# Store the temporary access token data to temporary variable
response=$(curl -s -k --request POST --header "Content-Type: text/plain" --data-binary "$api_key" "https://$dapURL/authn/$account/$dap_user/authenticate")

# Encode the temporary access token for use
token=$(echo -n $response | base64 | tr -d '\r\n')

# Connect to the Conjur/DAP REST API to bactch retrieve secret values"
secret_value=$(curl -s -k --header "Authorization: Token token=\"$token\"" "https://$dapURL/secrets?variable_ids=$account:variable:$variable_id1,$account:variable:$variable_id2")
secret_id1=$(echo $secret_value | awk -F ',' '{print $1}' | awk -F '[":]' '{print $4}')
secret_id2=$(echo $secret_value | awk -F ',' '{print $2}' | awk -F '[":]' '{print $4}')
secret_value1=$(echo $secret_value | awk -F ',' '{print $1}' | awk -F '[":]' '{print $7}')
secret_value2=$(echo $secret_value | awk -F ',' '{print $2}' | awk -F '[":]' '{print $7}')
  echo " "
  echo "---- Retrieving Secret Value 1 -----------"
  echo "Secret ID 1: $secret_id1"
  echo "Secret Value 1: $secret_value1"
  echo " "
  echo "---- Retrieving Secret Value 2 -----------"
  echo "Secret ID 2: $secret_id2"
  echo "Secret Value 2: $secret_value2"
