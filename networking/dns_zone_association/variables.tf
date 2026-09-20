variable "zone_id" {
  type = string
}

variable "vpc_ids" {
  description = "VPC IDs to associate with the zone. Explicit, not auto-discovered, so this doesn't silently attach to every VPC in the account."
  type        = list(string)
}
