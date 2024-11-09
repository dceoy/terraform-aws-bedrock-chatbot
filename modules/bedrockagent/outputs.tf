output "bedrock_agent_ids" {
  description = "Bedrock agent IDs"
  value       = { for k, v in aws_bedrockagent_agent.genai : k => v.agent_id }
}

output "bedrock_agent_versions" {
  description = "Bedrock agent versions"
  value       = { for k, v in aws_bedrockagent_agent.genai : k => v.agent_version }
}

output "bedrock_agent_iam_role_arn" {
  description = "Bedrock agent IAM role ARN"
  value       = length(aws_iam_role.genai) > 0 ? aws_iam_role.genai[0].arn : null
}

output "bedrock_agent_alias_arns" {
  description = "Bedrock agent alias ARNs"
  value       = { for k, v in aws_bedrockagent_agent_alias.genai : k => v.agent_alias_arn }
}
