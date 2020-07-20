# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------


# Use below code as backup to dependency block as last resort
// data "terraform_remote_state" "vpc" {
//     backend = "gcs"
//   config = {
//     bucket         = "tky-drone-demo-stage"
//     prefix         = "terraform/state"
//     region         = "asia-northeast1"
//   }
// }

terraform {
  source = "github.com/tkam8/drone-demo-module//ansible_files?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../terragrunt.hcl"
}

# New Terragrunt feature in v.019, alternative to terraform_remote_state. Provide mock outputs to use when a module hasn’t been applied yet.
dependency "f5" {
  config_path = "../functions/f5"

  mock_outputs = {
    f5_public_ip    = "1.1.1.1"
    f5_private_ip   = "2.2.2.2"
  }
}

dependency "nginx" {
  config_path = "../functions/nginx"

  mock_outputs = {
    #nginx_public_ip   = "4.4.4.4"
    #nginx_private_ip  = "5.5.5.5"
    nginx_instancegroup_self_link = "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-apcj-japan/regions/asia-northeast1/instancegroup/mock-ig1"
  }
}

dependency "consul" {
  config_path = "../functions/consul"

  mock_outputs = {
    consul_public_ip   = "6.6.6.6"
    consul_private_ip  = "7.7.7.7"
  }
}

dependency "gke" {
  config_path = "../functions/gke_cluster"

  mock_outputs = {
    gke_cluster_name    = "clusterName"
    gke_endpoint        = "3.3.3.3"
    cluster_username    = "admin"
    cluster_password    = "default"
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  terragrunt_path   = "${get_terragrunt_dir()}"
  f5_public_ip                  = dependency.f5.outputs.f5_public_ip
  f5_private_ip                 = dependency.f5.outputs.f5_private_ip
  #nginx_public_ip              = dependency.nginx.outputs.nginx_public_ip
  #nginx_private_ip             = dependency.nginx.outputs.nginx_private_ip
  nginx_instancegroup_self_link = dependency.nginx.outputs.nginx_instancegroup_self_link
  consul_public_ip              = dependency.consul.outputs.consul_public_ip
  consul_private_ip             = dependency.consul.outputs.consul_private_ip
  gke_cluster_name              = dependency.gke.outputs.gke_cluster_name
  gke_endpoint                  = dependency.gke.outputs.gke_endpoint

  app_tag_value         = "demostage"
  #use below var for multiple nginx deployements
  #gcp_f5_pool_members  = join("','", dependency.nginx.outputs.nginx_private_ip)
  cluster_username      = dependency.gke.outputs.cluster_username
  cluster_password      = dependency.gke.outputs.cluster_password
}
