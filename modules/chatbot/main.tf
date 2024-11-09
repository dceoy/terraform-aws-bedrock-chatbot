resource "aws_chatbot_slack_channel_configuration" "slack" {
  count              = var.chatbot_slack_workspace_id != null ? 1 : 0
  configuration_name = "${var.system_name}-${var.env_type}-chatbot-slack-channel-configuration"
  iam_role_arn       = aws_iam_role.slack[count.index].arn
  slack_channel_id   = var.chatbot_slack_channel_id
  slack_team_id      = var.chatbot_slack_workspace_id
  sns_topic_arns     = var.sns_topic_arns
  logging_level      = "NONE"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-chatbot-slack-channel-configuration"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "slack" {
  count                 = var.chatbot_slack_workspace_id != null ? 1 : 0
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
          Service = "chatbot.amazonaws.com"
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
  count = var.chatbot_slack_workspace_id != null && length(var.bedrock_agent_alias_ids) > 0 ? 1 : 0
  name  = "${var.system_name}-${var.env_type}-chatbot-iam-role-policy"
  role  = aws_iam_role.slack[count.index].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowInvokeBedrockAgent"
        Effect   = "Allow"
        Action   = ["bedrock:InvokeAgent"]
        Resource = var.bedrock_agent_alias_arns
      }
    ]
  })
}
