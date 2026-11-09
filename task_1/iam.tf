resource "google_service_account" "vm" {
  account_id   = "vm-label-reader"
  display_name = "VM label reader"

  depends_on = [google_project_service.api]
}


resource "google_project_iam_member" "vm_compute_viewer" {
  project = local.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.vm.email}"
}
