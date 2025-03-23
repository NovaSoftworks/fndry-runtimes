output "project_name" {
  value = google_project.project.name
}

output "project_id" {
  value = google_project.project.project_id
}

output "backend_bucket_name" {
  value = module.platform_remote_backend.bucket_name
}

output "subnet" {
  value = {
    name   = google_compute_subnetwork.subnet.name
    region = google_compute_subnetwork.subnet.region
    cidr   = google_compute_subnetwork.subnet.ip_cidr_range
  }
}
