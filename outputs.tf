output "foundation_outputs" {
  value = data.terraform_remote_state.foundation.outputs
}

output "novacp_prd_default" { 
  value = {
    project_id                  = module.novacp_prd_default.project_id
    subnet_id                   = module.novacp_prd_default.subnet_id
    kubernetes_cluster_name     = module.novacp_prd_default.kubernetes_cluster_name
    kubernetes_cluster_endpoint = module.novacp_prd_default.kubernetes_cluster_endpoint
  }
}
