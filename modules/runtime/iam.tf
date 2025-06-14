locals {
  project_number = google_project.project.number
  google_apis_sa_email = "${local.project_number}@cloudservices.gserviceaccount.com"
  gke_sa_email = "service-${local.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

# Google APIs Service Agent

resource "google_project_iam_member" "google_apis_sa_host_network_user" {
  depends_on =  [ google_project_service.project_compute_service ]
  project    = var.shared_vpc_host_project_id
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${local.google_apis_sa_email}"
}

# GKE Service Agent

resource "google_project_iam_member" "gke_sa_host_network_user" {
  depends_on = [ google_project_service.project_compute_service ]
  project    = var.shared_vpc_host_project_id
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${local.gke_sa_email}"
}

# This role is needed to allow the GKE Service Agent to manage network resources in the host project.
resource "google_project_iam_member" "gke_sa_host_host_service_agent_user" {
  depends_on = [ google_project_service.project_container_service ]
  project    = var.shared_vpc_host_project_id
  role       = "roles/container.hostServiceAgentUser"
  member     = "serviceAccount:${local.gke_sa_email}"
}

# This role is needed to allow the GKE Service Agent to manage firewall resources on the host project.
# TODO: replace with a custom role that only allows firewall management.
resource "google_project_iam_member" "gke_sa_host_security_admin" {
  depends_on = [ google_project_service.project_compute_service ]
  project    = var.shared_vpc_host_project_id
  role       = "roles/compute.securityAdmin"
  member     = "serviceAccount:${local.gke_sa_email}"
}
