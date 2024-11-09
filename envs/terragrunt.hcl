locals {
  repo_root = get_repo_root()
  env_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  extra_arguments "parallelism" {
    commands = get_terraform_commands_that_need_parallelism()
    arguments = [
      "-parallelism=16"
    ]
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = local.env_vars.locals.terraform_s3_bucket
    key            = "${basename(local.repo_root)}/${local.env_vars.locals.system_name}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.env_vars.locals.region
    encrypt        = true
    dynamodb_table = local.env_vars.locals.terraform_dynamodb_table
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.env_vars.locals.region}"
  default_tags {
    tags = {
      SystemName = "${local.env_vars.locals.system_name}"
      EnvType    = "${local.env_vars.locals.env_type}"
    }
  }
}
EOF
}

catalog {
  urls = [
    "${local.repo_root}/modules/bedrockagent",
    "${local.repo_root}/modules/chatbot"
  ]
}

inputs = {
  system_name                               = local.env_vars.locals.system_name
  env_type                                  = local.env_vars.locals.env_type
  iam_role_force_detach_policies            = true
  bedrock_agent_foundation_models           = { claude-3-5-sonnet-v2 = "anthropic.claude-3-5-sonnet-20241022-v2:0" }
  bedrock_agent_idle_session_ttl_in_seconds = 600
  bedrock_agent_skip_resource_in_use_check  = false
  bedrock_agent_prepare_agent               = true
  bedrock_provisioned_throughput_arns       = {}
  sns_topic_arns                            = []
  chatbot_slack_channel_id                  = "aws-account"
  # bedrock_agent_instruction                 = null
  # chatbot_slack_workspace_id                = null
}
