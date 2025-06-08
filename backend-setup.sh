#!/bin/bash

ENV_FILE=./env.sh
if test -f "$ENV_FILE"; then
    source $ENV_FILE
fi


# Create backend config file
cat > backend.tf << EOF
terraform {
  backend "gcs" {
    bucket = "$TF_BACKEND_BUCKET"
    prefix = "tfstate/platforms"
  }
}
EOF