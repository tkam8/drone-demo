

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/tkam8/drone-demo-module//gcp_nginx_systems?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../../terragrunt.hcl"
}

dependency "vpc" {
  config_path = "../../vpc"

  mock_outputs = {
    network             = "networkName"
    public_subnetwork   = "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-apcj-japan/regions/asia-northeast1/subnetworks/mock-subnet1"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  #skip_outputs = true
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  target_size          = "2"
  name_prefix          = "demo-stage"
  project              = "f5-gcs-4261-sales-apcj-japan"
  region               = "asia-northeast1"
  zone                 = "asia-northeast1-b"
  network              = dependency.vpc.outputs.network
  subnetwork           = dependency.vpc.outputs.public_subnetwork
  nginx_instance_type  = "n1-standard-2"
  consul_version       = "1.8.0"
  vault_addr           = get_env("VAULT_ADDR", "default")
  vault_role_dev       = "terry-iam-role-gce-dev"
  vault_ruleset_path   = "gcp/key/my-project-consuler2"
  app_tag_value        = "terrydemo"
}