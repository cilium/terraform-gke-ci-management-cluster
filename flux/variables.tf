variable "kubeconfig_path" {
  type        = string
  default     = "~/.kube/config"
  description = "Kubeconfig path is the kubeconfig to use to connect to the cluster."
}

variable "flux_namespace" {
  type        = string
  default     = "flux-system"
  description = "Namespace to use for flux installation"
}

variable "flux_targetpath" {
  type        = string
  default     = "config"
  description = "Relative path to the Git repository root where Flux manifests are committed."
}

variable "github_owner" {
  type        = string
  description = "Owner of the github repository for the flux to source control"
}

variable "repository_name" {
  type        = string
  description = "Name of the repository to use for flux."
}

variable "release_branch" {
  type        = string
  default     = "master"
  description = "Name of the branch to use for sync in flux source controller"
}
