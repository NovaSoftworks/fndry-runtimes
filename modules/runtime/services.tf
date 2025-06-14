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