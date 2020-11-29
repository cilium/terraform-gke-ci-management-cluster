output "cluster_name" {
  value       = google_container_cluster.management_cluster.name
  description = "Name of the created GKE cluster"
}

output "cluster_zone" {
  value       = google_container_cluster.management_cluster.location
  description = "Location the GKE cluster was created in"
}

output "cluster_endpoint" {
  value       = google_container_cluster.management_cluster.endpoint
  description = "Management GKE cluster endpoint"
}
