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


# New Terragrunt feature in v.019, alternative to terraform_remote_state. Provide mock outputs to use when a module hasn’t been applied yet.
dependency "f5" {
  config_path = "./terraform/functions/f5"

  mock_outputs = {
    gcp_F5_public_ip    = 1.1.1.1
    gcp_F5_private_ip   = 2.2.2.2
  }
}

dependency "nginx" {
  config_path = "./terraform/functions/nginx"

  mock_outputs = {
    gcp_nginx_data    = "networkName"
  }
}

dependency "gke" {
  config_path = "./terraform/functions/gke_cluster"

  mock_outputs = {
    gcp_gke_cluster_name    = "clusterName"
    gcp_gke_endpoint        = 3.3.3.3
  }
}

# -------------------------
# Setup variables for the Ansible inventory
# -------------------------
resource "local_file" "ansible_inventory_file" {
  content  = templatefile("${get_terragrunt_dir()}/stage/terraform/templates/ansible_inventory.tpl", {
    gcp_F5_public_ip      = dependency.f5.outputs.f5_public_ip
    gcp_F5_private_ip     = dependency.f5.outputs.f5_private_ip
    gcp_nginx_data        = dependency.nginx.outputs.nginx_public_ip
    gcp_gke_cluster_name  = dependency.gke.outputs.gke_cluster_name
    gcp_gke_endpoint      = dependency.gke.outputs.gke_endpoint
  })
  filename = "${get_terragrunt_dir()}/stage/ansible/playbooks/inventory/hosts"
}

resource "local_file" "ansible_f5_vars_file" {
  content  = templatefile("${get_terragrunt_dir()}/stage/terraform/templates/ansible_f5_vars.tpl", {
    gcp_tag_value         = var.app_tag_value
    #use below var for multiple nginx deployements
    #gcp_f5_pool_members  = join("','", dependency.nginx.outputs.nginx_private_ip)
    gcp_f5_pool_members   = dependency.nginx.outputs.nginx_private_ip
    gcp_gke_username      = dependency.gke.outputs.cluster_username
    gcp_gke_password      = dependency.gke.outputs.cluster_password
  })
  filename = "${get_terragrunt_dir()}/stage/ansible/playbooks/group_vars/F5_systems/vars"
}
