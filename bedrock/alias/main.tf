resource "aws_bedrockagent_agent_alias" "this" {
  agent_alias_name = var.alias_name
  agent_id         = var.agent_id
  description      = var.description
}
