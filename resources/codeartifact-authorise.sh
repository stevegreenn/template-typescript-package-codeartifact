#!/bin/bash

# Default values for the variables (useful for local development)
DEFAULT_CODEARTIFACT_AWS_ACCOUNT=account-id
DEFAULT_CODEARTIFACT_AWS_REGION=region
DEFAULT_CODEARTIFACT_DOMAIN=domain
DEFAULT_CODEARTIFACT_REPOSITORY_NAME=repository-name
DEFAULT_PACKAGE_SCOPE=@scope

# Set the domain and account values with the ability to override them using environment variables
CODEARTIFACT_AWS_ACCOUNT=${CODEARTIFACT_AWS_ACCOUNT:-$DEFAULT_CODEARTIFACT_AWS_ACCOUNT}
CODEARTIFACT_AWS_REGION=${CODEARTIFACT_AWS_REGION:-$DEFAULT_CODEARTIFACT_AWS_REGION}
CODEARTIFACT_DOMAIN=${CODEARTIFACT_DOMAIN:-$DEFAULT_CODEARTIFACT_DOMAIN}
CODEARTIFACT_REPOSITORY_NAME=${CODEARTIFACT_REPOSITORY_NAME:-$DEFAULT_CODEARTIFACT_REPOSITORY_NAME}
PACKAGE_SCOPE=${PACKAGE_SCOPE:-$DEFAULT_PACKAGE_SCOPE}

echo "[DEBUG] Variables set:"
echo "[DEBUG] CODEARTIFACT_AWS_ACCOUNT=$CODEARTIFACT_AWS_ACCOUNT"
echo "[DEBUG] CODEARTIFACT_AWS_REGION=$CODEARTIFACT_AWS_REGION"
echo "[DEBUG] CODEARTIFACT_DOMAIN=$CODEARTIFACT_DOMAIN"
echo "[DEBUG] CODEARTIFACT_REPOSITORY_NAME=$CODEARTIFACT_REPOSITORY_NAME"
echo "[DEBUG] PACKAGE_SCOPE=$PACKAGE_SCOPE"

# Login to CodeArtifact using the AWS CLI, capture output and error
echo "[INFO] Retrieving the CodeArtifact token..."
OUTPUT=$(aws codeartifact get-authorization-token --domain $CODEARTIFACT_DOMAIN --domain-owner $CODEARTIFACT_AWS_ACCOUNT --query authorizationToken --output text 2>&1)
RETVAL=$?

# Check for errors
if [ $RETVAL -ne 0 ]; then
    echo "[ERROR] Failed to retrieve CodeArtifact token."
    echo "[ERROR] AWS CLI Output: $OUTPUT"
    exit 1
else
    echo "[INFO] CodeArtifact token retrieved."
    # Ensure the token is not empty
    if [ -z "$OUTPUT" ]; then
        echo "[ERROR] Retrieved token is empty."
        exit 1
    else
        CODEARTIFACT_AUTH_TOKEN=$OUTPUT
    fi
fi

# Set the scope-specific registry URL and associated authorisation configuration
npm config set $PACKAGE_SCOPE:registry=https://$CODEARTIFACT_DOMAIN-$CODEARTIFACT_AWS_ACCOUNT.d.codeartifact.$CODEARTIFACT_AWS_REGION.amazonaws.com/npm/$CODEARTIFACT_REPOSITORY_NAME/
npm config set //$CODEARTIFACT_DOMAIN-$CODEARTIFACT_AWS_ACCOUNT.d.codeartifact.$CODEARTIFACT_AWS_REGION.amazonaws.com/npm/$CODEARTIFACT_REPOSITORY_NAME/:_authToken=$CODEARTIFACT_AUTH_TOKEN

# CodeArtifact authorised & the registry reset
echo "[SUCCESS] Operation complete."
