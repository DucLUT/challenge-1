locals {
  clone_source = "vm2"
}

# 1. Snapshot of vm2's boot disk (works while vm2 is running)
resource "google_compute_snapshot" "backend" {
  name        = "backend-snapshot"
  zone        = local.zone
  source_disk = google_compute_instance.vm[local.clone_source].boot_disk[0].source
}

# 2. Image built from that snapshot
resource "google_compute_image" "backend" {
  name            = "backend-image"
  source_snapshot = google_compute_snapshot.backend.self_link
}

# 3. vm3: same settings as the other VMs, booted from the image, no startup script
resource "google_compute_instance" "vm3" {
  name         = "vm3"
  machine_type = local.machine_type
  zone         = local.zone
  tags         = ["ssh"]

  labels = {
    role   = "backend"
    backup = "yes"
  }

  boot_disk {
    initialize_params {
      image = google_compute_image.backend.self_link
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = google_service_account.vm.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    network = "default"
    access_config {}
  }

  depends_on = [google_project_service.api, google_project_iam_member.vm_compute_viewer]
}
