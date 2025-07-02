variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "assign_ipv6" {
  type    = bool
  default = false
}

variable "environment" {
  type = string
}

variable "subnets" {
  type = list(object({
    availability_zone_id = string
    cidr                 = string
    tags                 = map(string)
  }))
}

/*
variable "public_subnets" {
    type = any
}

variable "worker_subnets" {
    type = any
}
*/
/*
variable "subnet_cidrs" {
  type = list(object({
    cidr = string
    type = string
  }))
}
*/
