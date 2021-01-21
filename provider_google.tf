provider "google" {
  credentials = file("./secrets/service-account.${var.svc_account_key}.key.json")
  project     = var.project_id
  region      = var.cluster_location
}
