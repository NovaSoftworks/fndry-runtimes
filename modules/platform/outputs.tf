output "project_name" {
  value = google_project.project.name
}

output "project_id" {
  value = google_project.project.project_id
}

output "subnet" {
  value = {
    name   = google_compute_subnetwork.subnet.name
    region = google_compute_subnetwork.subnet.region
    cidr   = google_compute_subnetwork.subnet.ip_cidr_range
  }
}
