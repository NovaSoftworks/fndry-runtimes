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


module "novacp_prd_default" {
  source = "./modules/runtime"

  billing_account_id         = local.billing_account_id
  parent_folder_id           = data.terraform_remote_state.foundation.outputs.prd.runtimes_folder_id
  environment                = "prd"
  shared_vpc_host_project_id = data.terraform_remote_state.foundation.outputs.prd.shared_vpc_host_project_id
  shared_vpc_id              = data.terraform_remote_state.foundation.outputs.prd.shared_vpc_id
  purpose                    = "default"
  region                     = "europe-west1"
  zone                       = "b"
  base_cidr                  = "10.0.0.0/21"
  node_type                  = "e2-standard-4"
  node_count                 = 1
}
