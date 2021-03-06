resource google_container_cluster management_cluster {
  provider = google-beta

  name               = var.cluster_name
  location           = var.cluster_location

  # Create a node pool with one node and immediately delete it so that we can
  # use our own managed node pool.
  initial_node_count = 1
  remove_default_node_pool = true

  network            = google_compute_network.management_cluster_vpc.self_link
  subnetwork         = google_compute_subnetwork.management_cluster_subnets[var.cluster_location].self_link

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  networking_mode   = "VPC_NATIVE"
  datapath_provider = "ADVANCED_DATAPATH"
  ip_allocation_policy { }

  addons_config {
    config_connector_config {
      enabled = true
    }

    dns_cache_config {
      enabled = true
    }

    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource google_container_node_pool management_cluster {
  name               = "${var.cluster_name}-np1"
  location           = var.cluster_location
  cluster            = google_container_cluster.management_cluster.name

  node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type
    image_type   = var.node_image_type

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    labels = {
      "node-pool"                 = "np1"
      "gke-ci-management-cluster" = var.cluster_name
    }

    tags = [ "gke-ci-management-cluster" ]

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }

  lifecycle {
    create_before_destroy = true
  }
}
