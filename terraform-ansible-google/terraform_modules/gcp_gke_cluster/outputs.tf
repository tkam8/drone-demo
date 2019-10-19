
output "gke_endpoint" {
  value = data.google_container_cluster.primary.endpoint
}

output "gke_cluster_name" {
  description = "Name of GKE cluster"
  value = google_container_cluster.primary.name
}