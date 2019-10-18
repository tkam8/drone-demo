output "network" {
  description = "A reference (self_link) to the VPC network"
  value       = module.cdn_network.network
}

output "allowed_networks" {
  description = "The public networks that is allowed access to the public_restricted subnetwork of the network"
  value        = var.allowed_networks
}

# -------------------------
# Public Subnetwork Outputs
# -------------------------

output "public_subnetwork" {
  description = "A reference (self_link) to the public subnetwork"
  value       = module.cdn_network.public_subnetwork
}

output "public_subnetwork_cidr_block" {
  value = module.cdn_network.public_subnetwork_cidr_block
}

output "public_subnetwork_gateway" {
  value = module.cdn_network.public_subnetwork_gateway
}

output "public_subnetwork_secondary_cidr_block" {
  value = module.cdn_network.public_subnetwork_secondary_cidr_block
}

# -------------------------
# Private Subnetwork Outputs
# -------------------------

output "private_subnetwork" {
  description = "A reference (self_link) to the private subnetwork"
  value       = module.cdn_network.private_subnetwork
}

output "private_subnetwork_cidr_block" {
  value = module.cdn_network.private_subnetwork_cidr_block
}

output "private_subnetwork_gateway" {
  value = module.cdn_network.private_subnetwork_gateway
}

output "private_subnetwork_secondary_cidr_block" {
  value = module.cdn_network.private_subnetwork_secondary_cidr_block
}

# -------------------------
# Access Tier - Network Tags
# -------------------------

output "public" {
  description = "The network tag string used for the public access tier"
  value       = module.network_firewall.public
}

output "private" {
  description = "The network tag string used for the private access tier"
  value       = module.network_firewall.private
}

output "private_persistence" {
  description = "The network tag string used for the private-persistence access tier"
  value       = module.network_firewall.private_persistence
}

# -------------------------
# Instance Info (primarily for testing)
# -------------------------

# output "f5_public_ip" {
#   description = "Public IP of F5 device"
#   value = module.gcp_f5_standalone.google_compute_instance.network_interface.0.access_config.0.nat_ip
# }

# output "f5_private_ip" {
#   description = "Private IP of F5 device"
#   value = module.gcp_f5_standalone.google_compute_instance.network_interface.0.network_ip
# }

output "nginx_public_ip" {
  description = "Public IP of NGINX device"
  value = module.gcp_nginx1.nginx_public_ip
}

output "nginx_private_ip" {
  description = "Private IP of NGINX device"
  value = module.gcp_nginx1.nginx_private_ip
}

output "gke_cluster_name" {
  description = "Name of GKE cluster"
  value = module.gcp_gke_cluster1.gke_cluster_name
}

output "gke_endpoint" {
  description = "The IP address of this cluster's Kubernetes master"
  value = module.gcp_gke_cluster1.gke_endpoint
}
