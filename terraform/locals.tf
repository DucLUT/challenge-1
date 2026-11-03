locals {
  project_id = "project-579396d2-7426-4596-923"
  region     = "us-central1"

  machine_type = "e2-medium"
  web_tag      = "web"

  health_check_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  iap_ranges          = ["35.235.240.0/20"]

  apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "secretmanager.googleapis.com",
    "artifactregistry.googleapis.com",
  ]
}
