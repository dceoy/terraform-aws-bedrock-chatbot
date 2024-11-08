variable "system_name" {
  description = "System name"
  type        = string
  default     = "gai"
}

variable "env_type" {
  description = "Environment type"
  type        = string
  default     = "dev"
}

variable "iam_role_force_detach_policies" {
  description = "Whether to force detaching any IAM policies the IAM role has before destroying it"
  type        = bool
  default     = true
}

variable "sns_topic_arns" {
  description = "SNS topic ARNs"
  type        = list(string)
  default     = []
}

variable "chatbot_slack_workspace_id" {
  description = "Chatbot Slack workspace ID"
  type        = string
  default     = null
}

variable "chatbot_slack_channel_id" {
  description = "Chatbot Slack channel ID"
  type        = string
  default     = "aws-account"
}

variable "bedrock_agent_alias_arns" {
  description = "Bedrock agent alias ARNs"
  type        = list(string)
  default     = []
}
