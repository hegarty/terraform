variable "name" {
  type = string
}

variable "instance_types" {
  type = list(string)
}

variable "ami_type" {
  type = string
}

variable "capacity_type" {
  type = string
}

variable "block_device_mappings" {
  type = list(object({
    device_name = string
    ebs = object({
      volume_size = number
      volume_type = string
      encrypted   = bool
    })
  }))
}

variable "metadata_options" {
  type = list(object({
    http_tokens = string
    http_put_response_hop_limit = string
  }))
}

variable "associate_public_ip_address" {
  type = bool
}

variable "cluster_name" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "subnet_ids" {
  type = map(string)
}

variable "user_data" {
  type = string
}

variable "scaling_desired_size" {
  type = number
}

variable "scaling_max_size" {
  type = number
}

variable "scaling_min_size" {
  type = number
}
