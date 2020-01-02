

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/tkam8/drone-demo-module//gcp_gke_cluster?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../../terragrunt.hcl"
}

dependency "network-firewall" {
  config_path = "../network-firewall"

  mock_outputs = {
    network      = "networkName"
    subnetwork   = "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-apcj-japan/regions/asia-northeast1/subnetworks/mock-subnet1"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix      = "demo-stage"
  project          = "f5-gcs-4261-sales-apcj-japan"
  region           = "asia-northeast1"
  zone             = "asia-northeast1-b"
  network          = dependency.network-firewall.outputs.network
  subnetwork       = dependency.network-firewall.outputs.public_subnetwork
  gke_username     = var.gke_username
  gke_password     = var.gke_password
}