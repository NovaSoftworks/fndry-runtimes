# Nova Cloud Platform Infrastructure

This repository contains the Terraform configurations for Nova Cloud's platform infrastructure layer. This layer deploys runtimes (projects) into environments, configures networking within the shared VPC, and sets up service accounts for application deployments.

## Important Notes

This platform layer creates the following resources in Google Cloud:
- Application projects within environment runtimes folders
- Subnet allocations within the shared VPC networks
- Service accounts for infrastructure and application deployments
- IAM configurations for runtimes resources
- Workload identity bindings

This is a configuration repository (not a reusable module) that defines specific runtimes deployments for Nova Crafting Platform's  infrastructure.

## Prerequisites

For the deployments to work, ensure that:
- The [bootstrap layer](https://github.com/NovaSoftworks/fndry-bootstrap) has been successfully deployed
- The [foundation layer](https://github.com/NovaSoftworks/fndry-foundation) has been successfully deployed with:
  - Environment folders and platforms subfolders created
  - Shared VPC networks established
  - The `foundation-infra-sa` service account created with appropriate permissions and Workload Identity Federation granting access from this repository
