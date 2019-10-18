terraform {
  # The modules used in this example have been updated with 0.12 syntax, which means the example is no longer
  # compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

# Configure the Google Cloud provider
provider "google" {
  credentials = "${file("#{gcp_creds.json}")}"
  project     = var.project
  region      = var.region
}

# -------------------------
# Create a Management Network for shared services
# -------------------------

module "cdn_network" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/gruntwork-io/terraform-google-network.git//modules/vpc-network?ref=v0.1.2"
  source      = "../../terraform_modules/gcp_vpc_network"
  name_prefix = var.name_prefix
  project     = var.project
  region      = var.region
}

# -------------------------
# Create GKE cluster and Node Pool
# -------------------------

module "gcp_gke_cluster1" {
  source           = "../../terraform_modules/gcp_gke_cluster"
  name_prefix      = var.name_prefix
  subnetwork       = module.gcp_vpc_network.public_subnetwork_name
  zone             = var.zone
}

module "gcp_gke_nodepool1" {
  source           = "../../terraform_modules/gcp_gke_nodepool"
  name_prefix      = var.name_prefix
  machine_type     = var.gke_instance_type
}

# -------------------------
# Create F5
# -------------------------

# module "gcp_f5_standalone" {
#   source           = "../../terraform_modules/gcp_f5_standalone_1NIC"
#   name_prefix      = var.name_prefix
#   subnetwork       = module.gcp_vpc_network.public_subnetwork_name
#   project          = var.project
#   region           = var.region
#   zone             = var.zone
#   machine_type     = var.f5_instance_type
# }

# -------------------------
# Create NGINX
# -------------------------

module "gcp_nginx1" {
  source           = "../../terraform_modules/gcp_nginx_systems"
  name_prefix      = var.name_prefix
  subnetwork       = module.gcp_vpc_network.public_subnetwork_name
  project          = var.project
  zone             = var.zone
  machine_type     = var.nginx_instance_type
}

# -------------------------
# Setup variables for the Ansible inventory
# -------------------------

data "template_file" "ansible_inventory" {
  template = file("./templates/ansible_inventory.tpl")
  vars = {
    gcp_F5_public_ip  = module.gcp_f5_standalone.f5_public_ip
    gcp_F5_private_ip = module.gcp_f5_standalone.f5_private_ip
    gcp_nginx_data    = join("\n", module.gcp_nginx1.nginx_public_ip)
    gke_cluster_name  = module.gcp_gke_cluster1.name
    gke_endpoint      = module.gke_endpoint
  }
}

resource "local_file" "ansible_inventory_file" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "../ansible/playbooks/inventory/hosts"
}

data "template_file" "ansible_f5_vars" {
  template = file("./templates/ansible_f5_vars.tpl")
  vars = {
    gcp_tag_value = var.app_tag_value
  }
}

resource "local_file" "ansible_f5_vars_file" {
  content  = data.template_file.ansible_f5_vars.rendered
  filename = "../ansible/playbooks/group_vars/F5_systems/vars"
}


# -------------------------
# Create instances to tag & test connectivity with
# -------------------------

# data "google_compute_zones" "available" {
#   project = var.project
#   region  = var.region
# }

# // This instance acts as an arbitrary internet address for testing purposes
# resource "google_compute_instance" "default_network" {
#   name         = "${var.name_prefix}-default-network"
#   machine_type = "n1-standard-1"
#   zone         = data.google_compute_zones.available.names[0]
#   project      = var.project

#   allow_stopping_for_update = true

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
#     }
#   }

#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral IP
#     }
#   }
# }

# resource "google_compute_instance" "public_with_ip" {
#   name         = "${var.name_prefix}-public-with-ip"
#   machine_type = "n1-standard-1"
#   zone         = data.google_compute_zones.available.names[0]
#   project      = var.project

#   allow_stopping_for_update = true

#   tags = [module.management_network.public]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
#     }
#   }

#   network_interface {
#     subnetwork = module.management_network.public_subnetwork

#     access_config {
#       // Ephemeral IP
#     }
#   }
# }

# resource "google_compute_instance" "public_without_ip" {
#   name         = "${var.name_prefix}-public-without-ip"
#   machine_type = "n1-standard-1"
#   zone         = data.google_compute_zones.available.names[0]
#   project      = var.project

#   allow_stopping_for_update = true

#   tags = [module.management_network.public]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
#     }
#   }

#   network_interface {
#     subnetwork = module.management_network.public_subnetwork
#   }
# }

# resource "google_compute_instance" "private_public" {
#   name         = "${var.name_prefix}-private-public"
#   machine_type = "n1-standard-1"
#   zone         = data.google_compute_zones.available.names[0]
#   project      = var.project

#   allow_stopping_for_update = true

#   tags = [module.management_network.private]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
#     }
#   }

#   network_interface {
#     subnetwork = module.management_network.public_subnetwork
#   }
# }

# resource "google_compute_instance" "private" {
#   name         = "${var.name_prefix}-private"
#   machine_type = "n1-standard-1"
#   zone         = data.google_compute_zones.available.names[0]
#   project      = var.project

#   allow_stopping_for_update = true

#   tags = [module.management_network.private]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
#     }
#   }

#   network_interface {
#     subnetwork = module.management_network.private_subnetwork
#   }
# }

# resource "google_compute_instance" "private_persistence" {
#   name         = "${var.name_prefix}-private-persistence"
#   machine_type = "n1-standard-1"
#   zone         = data.google_compute_zones.available.names[0]
#   project      = var.project

#   allow_stopping_for_update = true

#   tags = [module.management_network.private_persistence]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
#     }
#   }

#   network_interface {
#     subnetwork = module.management_network.private_subnetwork
#   }
# }