output "project_name" {
  value = google_project.project.name
}

output "project_id" {
  value = google_project.project.project_id
}

output "subnet_id" {
  value = google_compute_subnetwork.subnet.id
}

output "kubernetes_cluster_name" {
  value = module.kubernetes_cluster.cluster_name
}

output "kubernetes_cluster_endpoint" {
  value = module.kubernetes_cluster.cluster_endpoint
}

output "kubernetes_cluster_ca_certificate" {
  value     = module.kubernetes_cluster.cluster_ca_certificate
  sensitive = true
}