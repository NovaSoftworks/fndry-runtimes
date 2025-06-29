
variable "billing_account_id" {
  type        = string
  description = "The alphanumerical ID of the billing account in Google Cloud to use for the runtime."
}

variable "environment" {
  type        = string
  description = "The 3 characters long name of the environment (e.g. prd)."

  validation {
    condition     = length(var.environment) == 3
    error_message = "The short name of the environment must be 3 characters long."
  }
}

variable "shared_vpc_host_project_id" {
  type        = string
  description = ""
}

variable "shared_vpc_id" {
  type = string
}

variable "parent_folder_id" {
  type        = string
  description = "The ID of the parent folder where the runtime will project be created 9 (e.g. folder/123456789)."
}

variable "purpose" {
  type        = string
  description = "The purpose of this runtime (e.g. myapp)."
}

variable "region" {
  type        = string
  description = "The unabbreviated region where the runtime will be created (e.g. europe-west4)."
}

variable "zone" {
  type        = string
  description = "The zone within the region (e.g. a)."
}

variable "base_cidr" {
  type = string
}

variable "cluster_tools_node_type" {
  description = "The machine type for the node pool dedicated to cluster tools."
  type        = string
}

variable "cluster_tools_node_count" {
  description = "The number of nodes in the node pool dedicated to cluster tools."
  type        = number
}

variable "node_type" {
  description = "The machine type for the node pool."
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the node pool."
  type        = number
}