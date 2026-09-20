output "prompt_id" {
  value       = aws_bedrockagent_prompt.this.id
  description = "The ID of the Bedrock managed prompt"
}

output "prompt_arn" {
  value       = aws_bedrockagent_prompt.this.arn
  description = "The ARN of the Bedrock managed prompt"
}

output "prompt_version" {
  value       = aws_bedrockagent_prompt.this.version
  description = "The version of the Bedrock managed prompt"
}
