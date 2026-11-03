resource "google_compute_firewall" "allow_http" {
  name          = "allow-http"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.web_tag]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "allow_health_check" {
  name          = "allow-health-check"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  source_ranges = local.health_check_ranges
  target_tags   = [local.web_tag]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name          = "allow-iap-ssh"
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  source_ranges = local.iap_ranges
  target_tags   = [local.web_tag]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
