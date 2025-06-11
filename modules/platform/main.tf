locals {
  platform_name = "novacp-${var.environment}-${var.purpose}"

  region_parts           = split("-", var.region)
  region_parts_shortened = [for part in local.region_parts : substr(part, 0, 1)]
  region_number          = try(regex("([0-9]+)", var.region) != "", false) ? regex("([0-9]+)", var.region)[0] : ""
  region_short           = "${join("", local.region_parts_shortened)}${local.region_number}"
}

resource "random_id" "default" {
  byte_length = 4
}

resource "google_project" "project" {
  folder_id       = var.parent_folder_id
  name            = local.platform_name
  project_id      = "${local.platform_name}-${random_id.default.hex}"
  billing_account = var.billing_account_id
  deletion_policy = "DELETE" # TODO: remove after POC
}

resource "time_sleep" "for_60s_after_project" {
  depends_on      = [google_project.project]
  create_duration = "60s"
}

locals {
  project_number = google_project.project.number
  google_apis_sa_email = "${local.project_number}@cloudservices.gserviceaccount.com"
  gke_sa_email = "service-${local.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

# Services
resource "google_project_service" "project_compute_service" {
  depends_on = [time_sleep.for_60s_after_project]
  project    = google_project.project.project_id
  service    = "compute.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "project_container_service" {
  depends_on = [ time_sleep.for_60s_after_project ]
  project    = google_project.project.project_id
  service    = "container.googleapis.com"

  disable_on_destroy = true
}

# Roles

resource "google_project_iam_member" "google_apis_sa_host_network_user" {
  depends_on =  [ google_project_service.project_compute_service ]
  project    = var.shared_vpc_host_project_id
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${local.google_apis_sa_email}"
}

resource "google_project_iam_member" "gke_sa_host_network_user" {
  depends_on = [ google_project_service.project_compute_service, google_project_service.project_container_service ]
  project    = var.shared_vpc_host_project_id
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${local.gke_sa_email}"
}

resource "google_project_iam_member" "gke_sa_host_host_service_agent_user" {
  depends_on = [ google_project_service.project_compute_service, google_project_service.project_container_service ]
  project    = var.shared_vpc_host_project_id
  role       = "roles/container.hostServiceAgentUser"
  member     = "serviceAccount:${local.gke_sa_email}"
}

# Network
resource "google_compute_shared_vpc_service_project" "vpc_service" {
  depends_on      = [ google_project_service.project_compute_service ]
  host_project    = var.shared_vpc_host_project_id
  service_project = google_project.project.project_id
}

data "google_compute_network" "vpc" {
  name    = var.shared_vpc_id
  project = var.shared_vpc_host_project_id
}

resource "google_compute_subnetwork" "subnet" {
  project       = var.shared_vpc_host_project_id
  name          = "${local.platform_name}-${local.region_short}-subnet"
  network       = data.google_compute_network.vpc.self_link
  region        = var.region
  ip_cidr_range = cidrsubnet(var.base_cidr, 2, 0)

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = cidrsubnet(var.base_cidr, 2, 1)
  }

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = cidrsubnet(var.base_cidr, 1, 1)
  }
}

# Kubernetes Cluster
module "kubernetes_cluster" {
  depends_on = [ google_project_service.project_container_service ]
  source = "github.com/NovaSoftworks/tfr-gc-kubernetes?ref=v1.0.2"

  project_id = google_project.project.project_id
  location     = "${var.region}-${var.zone}"
  cluster_name = "${local.platform_name}-${local.region_short}-k8s"
  node_count = var.node_count
  node_type = var.node_type
  node_disks_size_gb = 50
  node_tags = [ var.environment, "allow-iap-ssh-ingress" ]
  network_id = data.google_compute_network.vpc.self_link
  subnet_id  = google_compute_subnetwork.subnet.id
  pods_range_name = "pods-range"
  services_range_name = "services-range"
}