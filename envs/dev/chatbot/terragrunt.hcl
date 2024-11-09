include "root" {
  path = find_in_parent_folders()
}

dependency "bedrockagent" {
  config_path = "../bedrockagent"
  mock_outputs = {
    bedrock_agent_alias_arns = {
      genai = "arn:aws:bedrock:aws-region:111122223333:agent-alias/AGENT12345/ALIAS12345"
    }
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  bedrock_agent_alias_arns = dependency.bedrockagent.outputs.bedrock_agent_alias_arns
}

terraform {
  source = "${get_repo_root()}/modules/chatbot"
}
