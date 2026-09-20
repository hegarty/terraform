output "release_name" {
  value = helm_release.this.name
}

output "release_status" {
  value = helm_release.this.status
}
