terraform {
  required_version = ">= 0.13"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.13.3"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.9.1"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.0.1"
    }
  }
}

provider "flux" {}

provider "kubectl" {
  config_path = var.kubeconfig_path
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}
