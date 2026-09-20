variable "identifier" {
  type        = string
  description = "RDS instance identifier"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the DB subnet group"
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security groups allowed to reach Postgres on 5432"
  default     = []
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to reach Postgres on 5432 (e.g. the VPC CIDR, when nodes don't carry a dedicated app security group)"
  default     = []
}

variable "engine_version" {
  type    = string
  default = "16"
}

variable "instance_class" {
  type        = string
  default     = "db.t4g.micro"
  description = "MVP default: smallest Graviton burstable class. Upgrade before real production load."
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type        = number
  default     = 100
  description = "Storage autoscaling ceiling in GB"
}

variable "db_name" {
  type = string
}

variable "master_username" {
  type    = string
  default = "app"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "Days of automated backups to retain"
}

variable "backup_window" {
  type    = string
  default = "07:00-08:00"
}

variable "maintenance_window" {
  type    = string
  default = "sun:08:30-sun:09:30"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "MVP default is single-AZ. See ADR-006 (single-AZ RDS MVP) before changing."
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "skip_final_snapshot" {
  type    = bool
  default = false
}

variable "apply_immediately" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
