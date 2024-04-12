#!/bin/bash

# Default values for the variables (useful for local development)
DEFAULT_CODEARTIFACT_AWS_ACCOUNT=400518886920
DEFAULT_CODEARTIFACT_AWS_REGION=eu-west-2
DEFAULT_CODEARTIFACT_DOMAIN=mta-immersion
DEFAULT_CODEARTIFACT_REPOSITORY_NAME=node-repository
DEFAULT_PACKAGE_SCOPE=@mta

# Set the domain and account values with the ability to override them using environment variables
CODEARTIFACT_AWS_ACCOUNT=${CODEARTIFACT_AWS_ACCOUNT:-$DEFAULT_CODEARTIFACT_AWS_ACCOUNT}
CODEARTIFACT_AWS_REGION=${CODEARTIFACT_AWS_REGION:-$DEFAULT_CODEARTIFACT_AWS_REGION}
CODEARTIFACT_DOMAIN=${CODEARTIFACT_DOMAIN:-$DEFAULT_CODEARTIFACT_DOMAIN}
CODEARTIFACT_REPOSITORY_NAME=${CODEARTIFACT_REPOSITORY_NAME:-$DEFAULT_CODEARTIFACT_REPOSITORY_NAME}
PACKAGE_SCOPE=${PACKAGE_SCOPE:-$DEFAULT_PACKAGE_SCOPE}

# Login to CodeArtifact using the AWS CLI
echo [INFO] Retrieving the CodeArtifact token...
CODEARTIFACT_AUTH_TOKEN=$(aws codeartifact get-authorization-token --domain $CODEARTIFACT_DOMAIN --domain-owner $CODEARTIFACT_AWS_ACCOUNT --query authorizationToken --output text)
echo [INFO] CodeArtifact token retrieved.

# Set the scope-specific registry URL and associated authorisation configuration
npm config set $PACKAGE_SCOPE:registry=https://$CODEARTIFACT_DOMAIN-$CODEARTIFACT_AWS_ACCOUNT.d.codeartifact.$CODEARTIFACT_AWS_REGION.amazonaws.com/npm/$CODEARTIFACT_REPOSITORY_NAME/
npm config set //$CODEARTIFACT_DOMAIN-$CODEARTIFACT_AWS_ACCOUNT.d.codeartifact.$CODEARTIFACT_AWS_REGION.amazonaws.com/npm/$CODEARTIFACT_REPOSITORY_NAME/:_authToken=$CODEARTIFACT_AUTH_TOKEN
echo [INFO] CodeArtifact registry and authorisation token set.

# CodeArtifact authorised & the registry reset
echo [SUCCESS] Operation complete.
