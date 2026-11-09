locals {
  project_id = "project-579396d2-7426-4596-923"
  region     = "us-central1"
  zone       = "us-central1-a"

  machine_type  = "e2-medium"
  machine_image = "debian-cloud/debian-12"
  vm = {
    vm1 = "frontend"
    vm2 = "backend"
  }

  iap_ranges = ["35.235.240.0/20"]

  apis = [
    "compute.googleapis.com",
    "iap.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "secretmanager.googleapis.com",
    "artifactregistry.googleapis.com",
  ]
}
