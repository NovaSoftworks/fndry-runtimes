data "terraform_remote_state" "foundation" {
  backend = "gcs"
  config = {
    bucket = var.foundation_state_bucket
    prefix = "tfstate/foundation"
  }
}

data "google_billing_account" "acct" {
  display_name = var.billing_account
  open         = true
}

locals {
  billing_account_id  = data.google_billing_account.acct.id
  platforms_folder_id = data.terraform_remote_state.foundation.outputs.prd_platforms_folder_id
}


module "poc_prd" {
  source = "./modules/platform"

  parent_folder_id       = local.platforms_folder_id
  billing_account_id     = local.billing_account_id
  environment_short_name = "prd"
  purpose                = "poc"
}
