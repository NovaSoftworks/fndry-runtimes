output "foundation_outputs" {
  value = data.terraform_remote_state.foundation.outputs
}

output "prd_platforms" {
  //value = module.prd_platforms.subnet
  value = [
    for platform in module.prd_platforms : {
      name                = platform.project_name
      id                  = platform.project_id
      backend_bucket_name = platform.backend_bucket_name
      subnet              = platform.subnet
    }
  ]
}
