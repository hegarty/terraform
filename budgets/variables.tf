variable "budget_name" {
  type = string
}

variable "monthly_limit" {
  type        = number
  description = "Overall monthly budget ceiling in USD (the top of your alert_thresholds should equal this)"
}

variable "alert_thresholds" {
  type        = list(number)
  description = "Dollar amounts (of monthly_limit) at which to notify, e.g. [100, 150, 200, 250]"
  default     = [100, 150, 200, 250]
}

variable "notification_emails" {
  type        = list(string)
  description = "Email addresses to subscribe to the budget alert SNS topic"
}

variable "tags" {
  type    = map(string)
  default = {}
}
