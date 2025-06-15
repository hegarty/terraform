resource "aws_bedrockagent_agent" "this" {
  agent_name                  = var.name
  agent_resource_role_arn     = var.role_arn
  idle_session_ttl_in_seconds = var.idle_session_ttl
  foundation_model            = var.foundation_model

  instruction = var.instruction
}
