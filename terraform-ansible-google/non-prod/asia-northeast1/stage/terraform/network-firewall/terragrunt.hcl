
# -------------------------
# Attach Firewall Rules to allow inbound traffic to tagged instances
# -------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/tkam8/drone-demo-module//gcp_network_firewall?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../terragrunt.hcl"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    network             = "networkName"
    public_subnetwork   = "https://www.googleapis.com/compute/v1/networkSelflink"
    private_subnetwork  = "https://www.googleapis.com/compute/v1/networkSelflink"
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix        = "demo-stage"
  project            = "f5-gcs-4261-sales-apcj-japan"
  region             = "asia-northeast1"
  network            = dependency.vpc.outputs.network
  allowed_networks   = ["210.226.41.0/24"]

  public_subnetwork  = dependency.vpc.outputs.public_subnetwork
  private_subnetwork = dependency.vpc.outputs.private_subnetwork
}

