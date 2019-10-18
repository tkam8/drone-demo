# -------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# -------------------------

variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness across a project."
  type        = string
}

variable "project" {
  description = "The name of the GCP Project where all resources will be launched."
  type        = string
}

variable "region" {
  description = "The Region in which all GCP resources will be launched."
  type        = string
}

variable "allowed_networks" {
  description = "The public networks that is allowed access to the public_restricted subnetwork of the network"
  type        = list(string)
}

variable "zone" {
  description = "The zone to create the F5 in. Must be within the subnetwork region."
  type        = string
}

variable "f5_instance_type" {
  description = "The machine type of the instance."
  type        = string
}

variable "nginx_instance_type" {
  description = "The machine type of the instance."
  type        = string
}

variable "gke_instance_type" {
  description = "The name of a Google Compute Engine machine type."
  type        = string
}
