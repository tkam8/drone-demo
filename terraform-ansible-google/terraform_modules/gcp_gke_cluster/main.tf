terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

resource "google_container_cluster" "primary" {
  name               = "${var.name_prefix}-gke-cluster"
  location           = var.zone
  initial_node_count = 1

  subnetwork = var.subnetwork

  master_auth {
    username = "admin"
    password = "admin"

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    machine_type = var.gke_instance_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      env      = "test"
      platform = "gcp"
    }

    tags = [var.tag]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

# (Optional) Manage node pool in the GKE cluster separately from the cluster control plane.

# resource "google_container_node_pool" "primary_nodes" {
#   name       = "${var.name_prefix}-primary-nodes"
#   location   = var.zone
#   cluster    = google_container_cluster.primary.name
#   node_count = var.primary_node_count

#   management {
#     auto_repair = true
#   }
# }