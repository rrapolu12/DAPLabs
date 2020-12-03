#!/bin/bash
#
# Script Purpose:
# 	- Authenticate to Conjur/DAP REST API
#	- Demonstrate the process to authenticate to the Conjur/DAP REST API
#
#	- This demonstration will showcase how to add/update a secret value
#
#	General Process Workflow:
#	-------------------------
#	Step 1: Convert password to Base64 format
#	Step 2: Connect to Conjur/DAP REST API to retrieve API Key
#	Step 3: Connect to Conjur/DAP REST API to obtain Temporary Access Token
#	Step 4: Encode the Temporary Access Token to Base64 format
#	Step 5: Connect to Conjur/DAP REST API to perform action
#

# Global variables
dapURL=dap-master.cyber-ark-demo.local

# Prompt user for Conjur/DAP User
read -p "Enter DAP Admin User: " dap_user
read -p "Enter Password: " -s dap_pass
echo " "
read -p "Enter DAP Account (CAU): " account

# Prompt for Variable Information
echo " "
echo "Now enter the secret / variable value information:"
echo " "
read -p "Enter Variable ID: " secret_id
read -p "Enter Variable Value: " -s secret_value
echo " "

echo "------------------------------------------------------------------"
echo "This demonstration will showcase each step in the REST API process"
echo " "

# Obtain user API key 
echo "Step 1: Convert user password to Base64"
echo "-------"
echo " "
echo "Command to run:"
echo 'cred_base64=$(echo -n' $dap_user':'$dap_pass '| base64)'
cred_base64=$(echo -n $dap_user:$dap_pass | base64)
echo " "
echo "Base64 Value = $cred_base64"
echo " "

echo "Step 2: Connect to Conjur/DAP REST API to retrieve the user's API Key"
echo "-------"
echo " "
echo "Command to run:"
echo 'api_key=$(curl -s -k --header "Authorization: Basic' $cred_base64'" https://'$dapURL'/authn/'$account'/login)'
api_key=$(curl -s -k --header "Authorization: Basic $cred_base64" "https://$dapURL/authn/$account/login")
echo " "
echo "API Key Value =  $api_key"
echo " "


# Obtain Conjur/DAP Users temporary access token
# Store the temporary access token data to temporary variable
echo "Step 3: Connect to the Conjur/DAP REST API to obtain a temporary access token"
echo "-------"
echo " "
echo "Command to run:"
echo 'response=$(curl -s -k --request POST --header "Content-Type: text/plain" --data-binary "'$api_key'" "https://'$dapURL'/authn/'$account'/'$dap_user'/authenticate")'
response=$(curl -s -k --request POST --header "Content-Type: text/plain" --data-binary "$api_key" "https://$dapURL/authn/$account/$dap_user/authenticate")
echo " "
echo "Response = "
echo "$response"
echo " "

# Encode the temporary access token for use
echo "Step 4: Encode Temporary Access Token to Base64 format"
echo "-------"
echo " "
echo "Command to run:"
echo 'token=$(echo -n '$response' | base64 | tr -d ''\r\n'')'
token=$(echo -n $response | base64 | tr -d '\r\n')
echo " "
echo "Token = $token"
echo " "

# Create Variable
echo "Step 5: Connect to the Conjur/DAP REST API to add/update secret value"
echo "-------"
echo " "
echo "Command to run:"
echo 'curl -s -k --request POST --header "Authorization: Token token=\"'$token'\"" --data "'$secret_value'" "https://'$dapURL'/secrets/'$account'/variable/'$secret_id'"'
echo " "

