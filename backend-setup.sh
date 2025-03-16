#!/bin/bash

# Create backend config file
cat > backend.tf << EOF
terraform {
  backend "gcs" {
    bucket = "$TF_BACKEND_BUCKET"
    prefix = "tfstate/platforms"
  }
}
EOF