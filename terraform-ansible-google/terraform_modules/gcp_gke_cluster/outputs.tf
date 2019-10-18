
output "endpoint" {
  value = data.google_container_cluster.primary.endpoint
}

output "gke_cluster_name" {
  description = "Name of GKE cluster"
  value = module.gcp_gke_cluster1.google_container_cluster.name
}