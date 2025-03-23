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

# Terraform backend for the platform's team
module "platform_remote_backend" {
  source = "github.com/NovaSoftworks/tfr-gc-remote-backend?ref=v1.0.2"

  location   = "EU"
  project_id = google_project.project.project_id
  subdomain  = google_project.project.project_id
}

# Services
resource "google_project_service" "project_compute_service" {
  depends_on = [time_sleep.for_60s_after_project]
  project    = google_project.project.project_id
  service    = "compute.googleapis.com"

  disable_on_destroy = true
}

# Network
resource "google_compute_shared_vpc_service_project" "vpc_service" {
  depends_on      = [google_project_service.project_compute_service]
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
  ip_cidr_range = var.cidr
}
