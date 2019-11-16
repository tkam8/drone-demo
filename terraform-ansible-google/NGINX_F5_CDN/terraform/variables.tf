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

variable "gke_username" {
  description = "The username for gke cluster basic auth."
  type        = string
}

variable "gke_password" {
  description = "The password for gke cluster basic auth."
  type        = string
}

## Please check and update the latest DO URL from https://github.com/F5Networks/f5-declarative-onboarding/releases
variable "DO_URL" {
  description = "The URL for downloading F5 Declarative Onboarding." 
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.8.0/f5-declarative-onboarding-1.8.0-2.noarch.rpm"
}

## Please check and update the latest AS3 URL from https://github.com/F5Networks/f5-appsvcs-extension/releases/latest 
variable "AS3_URL" {
  description = "The URL for downloading F5 Application Services 3 extension." 
  default = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.15.0/f5-appsvcs-3.15.0-6.noarch.rpm"
}

variable "app_tag_value" {
  description = "The value used in the instance label, for service discovery (optional)"
  default = "terry"
}