terraform {
  required_version = ">= 0.14.0"

  required_providers {
    google = {
      version = "~> 3.55.0"
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  credentials = file("./secrets/service-account.${var.svc_account_key}.key.json")
  project     = var.project_id
  region      = var.cluster_location
}
