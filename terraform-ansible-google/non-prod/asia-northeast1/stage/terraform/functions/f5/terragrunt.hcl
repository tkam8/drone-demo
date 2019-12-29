 -------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com:tkam8/drone-demo-module.git//gcp_f5_standalone_1NIC?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "network-firewall" {
  config_path = "../network-firewall"

  mock_outputs = {
    network      = "networkName"
    subnetwork   = "networkSelflink"
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix       = var.name_prefix
  project           = var.project
  zone              = var.zone
  network           = dependency.network-firewall.outputs.network
  subnetwork        = dependency.network-firewall.outputs.public_subnetwork
  f5_instance_type  = var.f5_instance_type
  AS3_URL           = var.AS3_URL
  DO_URL            = var.DO_URL
}

