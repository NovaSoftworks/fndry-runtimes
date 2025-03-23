variable "foundation_state_bucket" {
  type        = string
  description = "The name of the bucket in Google Cloud where the foundation Terraform state file is stored."
}

variable "billing_account" {
  type        = string
  description = "The name of the billing account in Google Cloud to use for the platforms."
}

variable "platforms" {
  type = map(list(object({
    region  = string
    purpose = string
    cidr    = string
  })))
}
