variable "route-table_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type    = map(string)
  default = {}
}

variable "destination" {
  type    = string
  default = null
}

variable "gateway_id" {
  type    = string
  default = null
}

variable "nat_ids" {
  type    = map(string)
  default = {}
}

variable "destination_cidr" {
  type    = string
  default = null
}
