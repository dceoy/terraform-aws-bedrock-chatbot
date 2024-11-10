resource "aws_chatbot_slack_channel_configuration" "slack" {
  count                 = local.create_chatbot ? 1 : 0
  configuration_name    = "${var.system_name}-${var.env_type}-chatbot-slack-channel-configuration"
  iam_role_arn          = aws_iam_role.slack[count.index].arn
  slack_channel_id      = var.chatbot_slack_channel_id
  slack_team_id         = var.chatbot_slack_workspace_id
  guardrail_policy_arns = length(var.guardrail_policy_arns) > 0 ? var.guardrail_policy_arns : null
  sns_topic_arns        = length(var.sns_topic_arns) > 0 ? var.sns_topic_arns : null
  logging_level         = "NONE"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-chatbot-slack-channel-configuration"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "slack" {
  count                 = local.create_chatbot ? 1 : 0
  name                  = "${var.system_name}-${var.env_type}-chatbot-iam-role"
  description           = "Chatbot IAM role"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowChatbotAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "management.chatbot.amazonaws.com"
        }
        Action = ["sts:AssumeRole"]
      }
    ]
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-chatbot-iam-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role_policy" "bedrock" {
  count = local.create_chatbot ? 1 : 0
  name  = "${var.system_name}-${var.env_type}-chatbot-iam-role-policy"
  role  = aws_iam_role.slack[count.index].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowInvokeBedrockAgent"
        Effect = "Allow"
        Action = ["bedrock:InvokeAgent"]
        Resource = length(var.bedrock_agent_alias_arns) > 0 ? var.bedrock_agent_alias_arns : [
          "arn:aws:bedrock:${local.region}:${local.account_id}:agent-alias/*/*"
        ]
        Condition = length(var.bedrock_agent_alias_arns) > 0 ? {} : {
          StringEquals = {
            "aws:ResourceTag/SystemName" = var.system_name
            "aws:ResourceTag/EnvType"    = var.env_type
          }
        }
      }
    ]
  })
}
