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

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = null
}

variable "bedrock_agent_foundation_models" {
  description = "Foundation models for Bedrock agents (key: alias, value: foundation model ID)"
  type        = map(string)
  default     = {}
}

variable "bedrock_agent_idle_session_ttl_in_seconds" {
  description = "The number of seconds for which Bedrock keeps information about a user's conversation with the agent"
  type        = number
  default     = 600
  validation {
    condition     = var.bedrock_agent_idle_session_ttl_in_seconds >= 60 && var.bedrock_agent_idle_session_ttl_in_seconds <= 3600
    error_message = "Bedrock agent idle session TTL in seconds must be between 60 and 3600"
  }
}

variable "bedrock_agent_instruction" {
  description = "Instructions that tell Bedrock agents what it should do and how it should interact with users"
  type        = string
  default     = "You are an IT agent who solves customer's problems."
  validation {
    condition     = length(var.bedrock_agent_instruction) >= 40 && length(var.bedrock_agent_instruction) <= 4000
    error_message = "Bedrock agent instruction must be between 40 and 4000 characters"
  }
}

variable "bedrock_agent_skip_resource_in_use_check" {
  description = "Whether the in-use check is skipped when deleting Bedrock agents"
  type        = bool
  default     = true
}

variable "bedrock_agent_prepare_agent" {
  description = "Whether to prepare Bedrock agents after creation or modification"
  type        = bool
  default     = true
}

variable "bedrock_provisioned_throughput_arns" {
  description = "Provisioned Throughput ARNs for Bedrock agent aliases (key: alias, value: ARN)"
  type        = map(string)
  default     = {}
}
