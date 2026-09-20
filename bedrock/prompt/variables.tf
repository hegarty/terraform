variable "prompt_name" {
  type        = string
  description = "Name of the Bedrock managed prompt"
}

variable "description" {
  type        = string
  default     = null
  description = "Optional description of the prompt"
}

variable "default_variant" {
  type        = string
  default     = "default"
  description = "Name of the default prompt variant"
}

variable "model_id" {
  type        = string
  description = "Bedrock foundation model ID to associate with this prompt"
}

variable "system_prompt" {
  type        = string
  description = "System prompt text stored as a managed Bedrock prompt"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the prompt resource"
}
