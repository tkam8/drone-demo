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

# New Terragrunt feature in v.019, alternative to terraform_remote_state. Provide mock outputs to use when a module hasn’t been applied yet.
dependency "f5" {
  config_path = "../functions/f5"

  mock_outputs = {
    gcp_F5_public_ip    = "1.1.1.1"
    gcp_F5_private_ip   = "2.2.2.2"
  }
}

dependency "nginx" {
  config_path = "../functions/nginx"

  mock_outputs = {
    gcp_nginx_data    = "networkName"
    app_tag_value     = "testing"
    nginx_public_ip   = "4.4.4.4"
    nginx_private_ip  = "5.5.5.5"
  }
}

dependency "gke" {
  config_path = "../functions/gke_cluster"

  mock_outputs = {
    gcp_gke_cluster_name    = "clusterName"
    gcp_gke_endpoint        = "3.3.3.3"
    gcp_gke_username        = "admin"
    gcp_gke_password        = "default"
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  terragrunt_path       = "${get_terragrunt_dir()}"
  gcp_F5_public_ip      = dependency.f5.outputs.f5_public_ip
  gcp_F5_private_ip     = dependency.f5.outputs.f5_private_ip
  gcp_nginx_data        = dependency.nginx.outputs.nginx_public_ip
  gcp_gke_cluster_name  = dependency.gke.outputs.gke_cluster_name
  gcp_gke_endpoint      = dependency.gke.outputs.gke_endpoint

  gcp_tag_value         = dependency.nginx.outputs.app_tag_value
  #use below var for multiple nginx deployements
  #gcp_f5_pool_members  = join("','", dependency.nginx.outputs.nginx_private_ip)
  gcp_f5_pool_members   = dependency.nginx.outputs.nginx_private_ip
  gcp_gke_username      = dependency.gke.outputs.cluster_username
  gcp_gke_password      = dependency.gke.outputs.cluster_password
}
