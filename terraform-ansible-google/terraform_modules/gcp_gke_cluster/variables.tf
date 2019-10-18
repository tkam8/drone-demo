# -------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# -------------------------

variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness across a project."
  type        = string
}

variable "subnetwork" {
  description = "A reference (self_link) to the subnetwork to place the gke cluster in"
  type        = string
}

variable "zone" {
  description = "The zone to create the gke cluster in. Must be within the subnetwork region."
  type        = string
}

variable "primary_node_count" {
  description = "The number of nodes per instance group."
  type        = number
}

# -------------------------
# OPTIONAL PARAMETERS
# Generally, these values won't need to be changed.
# -------------------------

variable "tag" {
  description = "The GCP network tag to apply to the gke cluster host for firewall rules. Defaults to 'public', the expected public tag of this module."
  type        = string
  default     = "public"
}
