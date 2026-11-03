resource "google_compute_instance_template" "web_v1" {
  name_prefix  = "web-template-v1-"
  machine_type = local.machine_type
  tags         = [local.web_tag]

  disk {
    source_image = "debian-cloud/debian-12"
    boot         = true
    auto_delete  = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.web.id
    access_config {} # ephemeral external IP so apt-get can reach the internet
  }

  metadata = {
    startup-script = file("${path.module}/scripts/startup-v1.sh")
  }

  lifecycle {
    create_before_destroy = true
  }
}
