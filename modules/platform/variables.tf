
variable "billing_account_id" {
  type        = string
  description = "The alphanumerical ID of the billing account in Google Cloud to use for the platform."
}

variable "parent_folder_id" {
  type        = string
  description = "The ID of the parent folder where the platform will project be created 9 (e.g. folder/123456789)."
}

variable "environment_short_name" {
  type        = string
  description = "The 3 characters long name of the environment (e.g. prd)."

  validation {
    condition     = length(var.environment_short_name) == 3
    error_message = "The short name of the environment must be 3 characters long."
  }
}

variable "purpose" {
  type        = string
  description = "The purpose of this landing zone (e.g. myapp)."
}

