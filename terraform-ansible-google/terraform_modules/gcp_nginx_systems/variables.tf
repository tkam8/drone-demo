# -------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# -------------------------

# variable "instance_name" {
#   description = "The name of the VM instance"
#   type        = string
# }

variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness across a project."
  type        = string
}

variable "subnetwork" {
  description = "A reference (self_link) to the subnetwork to place the nginx in"
  type        = string
}

variable "zone" {
  description = "The zone to create the nginx in. Must be within the subnetwork region."
  type        = string
}

variable "nginx_instance_type" {
  description = "The machine type of the instance."
  type        = string
}

variable "project" {
  description = "The project to create the nginx in. Must match the subnetwork project."
  type        = string
}

# -------------------------
# OPTIONAL PARAMETERS
# Generally, these values won't need to be changed.
# -------------------------

variable "tag" {
  description = "The GCP network tag to apply to the nginx host for firewall rules. Defaults to 'public', the expected public tag of this module."
  type        = string
  default     = "public"
}

variable "source_image" {
  description = "The source image to build the VM using. Specified by path reference or by {{project}}/{{image-family}}"
  type        = string
  default     = "nginx-plus-ubuntu1804-v2019070118"
}

variable "startup_script" {
  description = "The script to be executed when the nginx starts. It can be used to install additional software and/or configure the host."
  type        = string
  default     = ""
}

variable "static_ip" {
  description = "A static IP address to attach to the instance. The default will allocate an ephemeral IP"
  type        = string
  default     = null
}