
# -------------------------
# Attach Firewall Rules to allow inbound traffic to tagged instances
# -------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com:tkam8/drone-demo-module.git//gcp_network_firewall?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    network             = "networkName"
    public_subnetwork   = "networkSelflink"
    private_subnetwork  = "networkSelflink"
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix        = var.name_prefix
  project            = var.project
  network            = dependency.vpc.outputs.network
  allowed_networks   = var.allowed_networks

  public_subnetwork  = dependency.vpc.outputs.public_subnetwork
  private_subnetwork = dependency.vpc.outputs.private_subnetwork
}

