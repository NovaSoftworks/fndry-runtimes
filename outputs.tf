output "foundation_outputs" {
  value = data.terraform_remote_state.foundation.outputs
}

output "prd_subnets" {
  //value = module.prd_platforms.subnet
  value = [
    for platform in module.prd_platforms : platform.subnet
  ]
}
