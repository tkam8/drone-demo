terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

# -------------------------
# Create an NGINX instance 
# -------------------------

resource "google_compute_instance" "nginx1" {
  project             = var.project
  name                = "${var.name_prefix}-nginx"
  machine_type        = var.nginx_instance_type
  zone                = var.zone

  labels = {
    app = var.app_tag_value
  }

  tags = [var.tag]

  boot_disk {
    initialize_params {
      image = var.source_image
    }
  }

  network_interface {
    subnetwork = var.subnetwork

    // If var.static_ip is set use that IP, otherwise this will generate an ephemeral IP
    access_config {
      nat_ip = var.static_ip
    }
  }

  metadata_startup_script  = var.startup_script
     
}