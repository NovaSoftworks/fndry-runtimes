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
  billing_account_id = data.google_billing_account.acct.id
}


module "prd_platforms" {
  for_each = {
    for p in var.platforms.prd : "prd-${p.purpose}" => p
  }
  source = "./modules/platform"

  billing_account_id         = local.billing_account_id
  parent_folder_id           = data.terraform_remote_state.foundation.outputs.prd.platforms_folder_id
  environment                = "prd"
  shared_vpc_host_project_id = data.terraform_remote_state.foundation.outputs.prd.shared_vpc_host_project_id
  shared_vpc_id              = data.terraform_remote_state.foundation.outputs.prd.shared_vpc_id
  purpose                    = each.value.purpose
  region                     = each.value.region
  cidr                       = each.value.cidr
}
