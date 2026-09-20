variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ec2_name" {
  type = string
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "nginx_message" {
  type = string
}

variable "ingress_cidr_blocks" {
  description = "CIDRs allowed to reach the test instance on any port"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
