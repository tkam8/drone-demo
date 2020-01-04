# -------------------------
# Create a Management Network for shared services
# -------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/tkam8/drone-demo-module//gcp_vpc_network?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../terragrunt.hcl"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# Make sure to specify cidr blocks different from any existing networks
inputs = {
  name_prefix          = "demo-stage"
  project              = "f5-gcs-4261-sales-apcj-japan"
  region               = "europe-west2"
  cidr_block           = "10.7.0.0/16"
  secondary_cidr_block = "10.8.0.0/16"
}
