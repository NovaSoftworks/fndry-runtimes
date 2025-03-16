resource "random_id" "default" {
  byte_length = 4
}

resource "google_project" "project" {
  folder_id       = var.parent_folder_id
  name            = "novacp-${var.environment_short_name}-${var.purpose}"
  project_id      = "novacp-${var.environment_short_name}-${var.purpose}-${random_id.default.hex}"
  billing_account = var.billing_account_id
  deletion_policy = "DELETE" # TODO: remove after POC
}

resource "time_sleep" "for_60s_after_project" {
  depends_on      = [google_project.project]
  create_duration = "60s"
}

# Services
resource "google_project_service" "project_compute_service" {
  depends_on = [time_sleep.for_60s_after_project]
  project    = google_project.project.project_id
  service    = "compute.googleapis.com"

  disable_on_destroy = true
}
