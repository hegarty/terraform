variable "units" {
  description = "Map of parent OU name => list of child OU names to create under it"
  type        = map(list(string))
}

variable "root_ou_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
