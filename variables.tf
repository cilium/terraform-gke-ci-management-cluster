variable subnets {
  type    = map(string)
  # this is based on default network's config
  default = {
    us-central1	             = "10.128.0.0/20"
    europe-west1             = "10.132.0.0/20"
    us-west1                 = "10.138.0.0/20"
    asia-east1               = "10.140.0.0/20"
    us-east1                 = "10.142.0.0/20"
    asia-northeast1          = "10.146.0.0/20"
    asia-southeast1          = "10.148.0.0/20"
    us-east4                 = "10.150.0.0/20"
    australia-southeast1     = "10.152.0.0/20"
    europe-west2             = "10.154.0.0/20"
    europe-west3             = "10.156.0.0/20"
    southamerica-east1       = "10.158.0.0/20"
    asia-south1              = "10.160.0.0/20"
    northamerica-northeast1  = "10.162.0.0/20"
    europe-west4             = "10.164.0.0/20"
    europe-north1            = "10.166.0.0/20"
    us-west2                 = "10.168.0.0/20"
    asia-east2               = "10.170.0.0/20"
    europe-west6             = "10.172.0.0/20"
    asia-northeast2          = "10.174.0.0/20"
    asia-northeast3          = "10.178.0.0/20"
    us-west3                 = "10.180.0.0/20"
    us-west4                 = "10.182.0.0/20"
  }
}

variable cluster_name {
  type        = string
  default     = "iso-test-management-cluster"
  description = "Name for the management cluster"
}

variable cluster_location {
  type        = string
  default     = "us-central1"
  description = "Location to create the GKE cluster in"
}

variable node_machine_type {
  type        = string
  default     = "n1-standard-2"
  description = "GCP machine type to use for the management Kubernetes cluster node"
}

variable node_image_type {
  type        = string
  default     = "COS_CONTAINERD"
  description = "Image to use for the Kubernetes node"
}

variable node_count {
  type        = number
  default     = 1
  description = "Number of worker nodes in the management cluster."
}

variable project_id {
  type        = string
  description = "GCP project to create the management cluster in"
}

variable svc_account_key {
  type        = string
  description = "Service account key name, must in path ./secrets/ in JSON format."
}
