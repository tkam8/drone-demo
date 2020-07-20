# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------


terraform {
  source = "git@github.com:f5vcdn/vCDN-terraform-modules//ansible_files?ref=v0.1"
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
    nginx_public_ip   = "networkName-eu"
    nginx_public_ip   = "4.4.4.4"
    nginx_private_ip  = "5.5.5.5"
  }
}

dependency "player_dash" {
  config_path = "../functions/player_dash"

  mock_outputs = {
    ubuntu_instance      = "instanceSelfLink"
    ubuntu_public_ip     = "6.6.6.6"
    ubuntu_private_ip    = "7.7.7.7"
  }
}

dependency "fluentd_external" {
  config_path = "../functions/fluentd_external"

  mock_outputs = {
    ubuntu_private_ip     = "9.9.9.9"
    ubuntu_public_ip      = "10.10.10.10"
  }
}


dependency "gke" {
  config_path = "../functions/gke_cluster"

  mock_outputs = {
    gke_cluster_name    = "clusterName-eu"
    gke_endpoint        = "3.3.3.3"
    cluster_username    = "admin"
    cluster_password    = "default"
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  terragrunt_path   = "${get_terragrunt_dir()}"
  f5_public_ip      = dependency.f5.outputs.f5_public_ip
  f5_private_ip     = dependency.f5.outputs.f5_private_ip
  nginx_public_ip   = dependency.nginx.outputs.nginx_public_ip
  gke_cluster_name  = dependency.gke.outputs.gke_cluster_name
  gke_endpoint      = dependency.gke.outputs.gke_endpoint

  app_tag_value               = "vcdnstage-eu"
  domain_name                 = "europe.runtest.org"
  f5aas_gslb_zone             = "runtest.org"
  #use below var for multiple nginx deployments
  #gcp_f5_pool_members        = join("','", dependency.nginx.outputs.nginx_private_ip)
  nginx_private_ip            = dependency.nginx.outputs.nginx_private_ip
  cluster_username            = dependency.gke.outputs.cluster_username
  cluster_password            = dependency.gke.outputs.cluster_password
  player_dash_public_ip       = dependency.player_dash.outputs.ubuntu_public_ip
  fluentd_external_private_ip = dependency.fluentd_external.outputs.ubuntu_private_ip
  fluentd_external_public_ip  = dependency.fluentd_external.outputs.ubuntu_public_ip
}
