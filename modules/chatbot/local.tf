data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id     = data.aws_caller_identity.current.account_id
  region         = data.aws_region.current.name
  create_chatbot = var.chatbot_slack_workspace_id != null && var.chatbot_slack_channel_id != null ? true : false
}
