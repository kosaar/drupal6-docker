#!/bin/bash

cd "$(dirname "$0")"

# Create a self-signed certificate for local development

# Certificate details
COUNTRY="US"
STATE="California"
LOCALITY="San Francisco"
ORGANIZATION="Development"
ORGANIZATIONAL_UNIT="IT"
COMMON_NAME="localhost"
EMAIL="dev@localhost.com"

# Generate the certificate and key
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout key.pem \
    -out cert.pem \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONAL_UNIT/CN=$COMMON_NAME/emailAddress=$EMAIL"
