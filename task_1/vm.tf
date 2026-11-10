resource "google_compute_instance" "vm" {
  for_each     = local.vm
  name         = each.key
  machine_type = local.machine_type
  zone         = local.zone
  tags         = ["ssh"]

  labels = {
    role = each.value
  }
  boot_disk {
    initialize_params {
      image = local.machine_image
    }
  }

  depends_on = [google_project_service.api, google_project_iam_member.vm_compute_viewer]

  metadata = {
    enable-oslogin  = "TRUE"
    startup-script  = file("${path.module}/scripts/setup_nginx.sh")
    check-labels-py = file("${path.module}/scripts/check_labels.py")
  }

  service_account {
    email  = google_service_account.vm.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    network = "default"
    access_config {

    }
  }
}




resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = local.iap_ranges
  target_tags   = ["ssh"]

  depends_on = [google_project_service.api]
}
