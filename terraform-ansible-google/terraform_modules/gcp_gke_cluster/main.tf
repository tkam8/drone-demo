terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

resource "google_container_cluster" "primary" {
  name               = "${var.name_prefix}-gke-cluster"
  location           = var.zone
  initial_node_count = 1
 
  network    = var.network
  subnetwork = var.subnetwork

  master_auth {
    username = "admin"
    password = "LWkCpSd8kf44m8Y2"

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}


# Setup data resource

data "google_container_cluster" "primary" {
  name       = "primary"
  location   = var.zone
}