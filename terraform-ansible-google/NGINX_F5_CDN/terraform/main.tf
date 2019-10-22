terraform {
  # The modules used in this example have been updated with 0.12 syntax, which means the example is no longer
  # compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

# Configure the Google Cloud provider
provider "google" {
  credentials = "${file("/tmp/gcp_creds.json")}"
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
  source           = "../../terraform_modules/gcp_vpc_network"
  name_prefix      = var.name_prefix
  project          = var.project
  region           = var.region
  allowed_networks = var.allowed_networks
}

# -------------------------
# Attach Firewall Rules to allow inbound traffic to tagged instances
# -------------------------

module "network_firewall" {
  source = "../../terraform_modules/gcp_network_firewall"

  name_prefix        = var.name_prefix
  project            = var.project
  network            = module.cdn_network.network
  allowed_networks   = var.allowed_networks

  public_subnetwork  = module.cdn_network.public_subnetwork
  private_subnetwork = module.cdn_network.private_subnetwork
}


# -------------------------
# Create GKE cluster and Node Pool
# -------------------------

module "gcp_gke_cluster1" {
  source           = "../../terraform_modules/gcp_gke_cluster"
  name_prefix      = var.name_prefix
  network          = module.cdn_network.network
  subnetwork       = module.cdn_network.public_subnetwork
  zone             = var.zone
}

module "gcp_gke_nodepool1" {
  source             = "../../terraform_modules/gcp_gke_nodepool"
  name_prefix        = var.name_prefix
  gke_instance_type  = var.gke_instance_type
  cluster_name       = module.gcp_gke_cluster1.gke_cluster_name
  zone               = var.zone
}

# -------------------------
# Create F5
# -------------------------

# module "gcp_f5_standalone" {
#   source            = "../../terraform_modules/gcp_f5_standalone_1NIC"
#   name_prefix       = var.name_prefix
#   subnetwork        = module.cdn_network.public_subnetwork_name
#   project           = var.project
#   region            = var.region
#   zone              = var.zone
#   f5_instance_type  = var.f5_instance_type
# }

# -------------------------
# Create NGINX
# -------------------------

module "gcp_nginx1" {
  source               = "../../terraform_modules/gcp_nginx_systems"
  name_prefix          = var.name_prefix
  subnetwork           = module.cdn_network.public_subnetwork_name
  project              = var.project
  zone                 = var.zone
  nginx_instance_type  = var.nginx_instance_type
}

# -------------------------
# Setup variables for the Ansible inventory
# -------------------------

# data "template_file" "ansible_inventory" {
#   template = file("./templates/ansible_inventory.tpl")
#   vars = {
#     #gcp_F5_public_ip     = module.gcp_f5_standalone.f5_public_ip
#     #gcp_F5_private_ip    = module.gcp_f5_standalone.f5_private_ip
#     gcp_nginx_data        = module.gcp_nginx1.nginx_public_ip
#     gcp_gke_cluster_name  = module.gcp_gke_cluster1.gke_cluster_name
#     gcp_gke_endpoint      = module.gcp_gke_cluster1.gke_endpoint
#   }
# }

# resource "local_file" "ansible_inventory_file" {
#   content  = data.template_file.ansible_inventory.rendered
#   filename = "../ansible/playbooks/inventory/hosts"
# }

resource "local_file" "ansible_inventory_file" {
  content  = templatefile("./templates/ansible_inventory.tpl", {
    #gcp_F5_public_ip     = module.gcp_f5_standalone.f5_public_ip
    #gcp_F5_private_ip    = module.gcp_f5_standalone.f5_private_ip
    gcp_nginx_data        = module.gcp_nginx1.nginx_public_ip
    gcp_gke_cluster_name  = module.gcp_gke_cluster1.gke_cluster_name
    gcp_gke_endpoint      = module.gcp_gke_cluster1.gke_endpoint
  })
  filename = "../ansible/playbooks/inventory/hosts"
}

# data "template_file" "ansible_f5_vars" {
#   template = file("./templates/ansible_f5_vars.tpl")
#   vars = {
#     gcp_tag_value = var.app_tag_value
#   }
# }

# resource "local_file" "ansible_f5_vars_file" {
#   content  = data.template_file.ansible_f5_vars.rendered
#   filename = "../ansible/playbooks/group_vars/F5_systems/vars"
# }

resource "local_file" "ansible_f5_vars_file" {
  content  = templatefile("./templates/ansible_f5_vars.tpl", {
    gcp_tag_value = var.app_tag_value
  })
  filename = "../ansible/playbooks/group_vars/F5_systems/vars"
}