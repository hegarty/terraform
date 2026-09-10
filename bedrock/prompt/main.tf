resource "aws_bedrockagent_prompt" "this" {
  name        = var.prompt_name
  description = var.description
  tags        = var.tags

  default_variant = var.default_variant

  variant {
    name          = var.default_variant
    template_type = "TEXT"
    model_id      = var.model_id

    template_configuration {
      text {
        text = var.system_prompt
      }
    }
  }
}
