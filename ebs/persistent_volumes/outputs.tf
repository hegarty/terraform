output "volume_ids" {
  description = "EBS volume IDs, keyed by volume name."
  value       = { for k, v in aws_ebs_volume.this : k => v.id }
}

output "availability_zones" {
  description = "Availability zone of each volume, keyed by volume name."
  value       = { for k, v in aws_ebs_volume.this : k => v.availability_zone }
}

output "sizes_gb" {
  description = "Size of each volume in GiB, keyed by volume name."
  value       = { for k, v in aws_ebs_volume.this : k => v.size }
}
