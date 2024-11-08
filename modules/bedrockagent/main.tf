resource "aws_bedrockagent_agent" "genai" {
  for_each                    = var.bedrock_agent_foundation_models
  agent_name                  = "${var.system_name}-${var.env_type}-bedrock-${each.key}-agent"
  description                 = "Bedrock agent for ${each.key} (${each.value})"
  agent_resource_role_arn     = aws_iam_role.genai.arn
  foundation_model            = each.value
  idle_session_ttl_in_seconds = var.bedrock_agent_idle_session_ttl_in_seconds
  instruction                 = var.bedrock_agent_instruction
  customer_encryption_key_arn = var.kms_key_arn
  skip_resource_in_use_check  = var.bedrock_agent_skip_resource_in_use_check
  prepare_agent               = var.bedrock_agent_prepare_agent
  tags = {
    Name    = "${var.system_name}-${var.env_type}-bedrock-${each.key}-agent"
    System  = var.system_name
    EnvType = var.env_type
  }
}

resource "aws_iam_role" "genai" {
  name                  = "${var.system_name}-${var.env_type}-bedrock-agent-iam-role"
  description           = "Bedrock agent IAM role"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowBedrockAgentAssumeRole"
        Effect = "Allow"
        Action = ["sts:AssumeRole"]
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.current.account_id
          }
          ArnLike = {
            "AWS:SourceArn" = "arn:aws:bedrock:${local.region}:${local.account_id}:agent/*"
          }
        }
      }
    ]
  })
  tags = {
    Name    = "${var.system_name}-${var.env_type}-bedrock-agent-iam-role"
    System  = var.system_name
    EnvType = var.env_type
  }
}

resources "aws_iam_role_policy" "genai" {
  name   = "${var.system_name}-${var.env_type}-bedrock-agent-iam-policy"
  role   = aws_iam_role.genai.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowBedrockAgentInvokeModel"
        Effect = "Allow"
        Action = ["bedrock:InvokeModel"]
        Resource = [
          "arn:aws:bedrock:${local.region}::foundation-model/*"
        ]
      }
    ]
  })
}

resource "aws_bedrockagent_agent_alias" "genai" {
  for_each         = aws_bedrockagent_agent.genai
  agent_alias_name = each.key
  agent_id         = each.value.agent_id
  description      = "Bedrock agent alias for ${each.key}"
  routing_configuration {
    agent_version          = each.value.agent_version
    provisioned_throughput = lookup(var.bedrock_provisioned_throughput_arns, each.key, null)
  }
  tags = {
    Name    = "${var.system_name}-${var.env_type}-bedrock-${each.key}-agent-alias"
    System  = var.system_name
    EnvType = var.env_type
  }
}
