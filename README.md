terraform-aws-bedrock-chatbot
=============================

Terraform modules for Bedrock-powered Slack Chatbot

[![CI](https://github.com/dceoy/terraform-aws-bedrock-chatbot/actions/workflows/ci.yml/badge.svg)](https://github.com/dceoy/terraform-aws-bedrock-chatbot/actions/workflows/ci.yml)

Installation
------------

1.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/terraform-aws-bedrock-chatbot.git
    $ cd terraform-aws-bedrock-chatbot
    ````

2.  Install [AWS CLI](https://aws.amazon.com/cli/) and set `~/.aws/config` and `~/.aws/credentials`.

3.  Install [Terraform](https://www.terraform.io/) and [Terragrunt](https://terragrunt.gruntwork.io/).

4.  Configure Slack client for AWS Chatbot and retrieve the Slack workspace ID.

5.  Set the Slack workspace ID in the environment variable `AWS_CHATBOT_SLACK_WORKSPACE_ID`.

    ```sh
    $ export AWS_CHATBOT_SLACK_WORKSPACE_ID=<slack-workspace-id>
    ```

6.  Initialize Terraform working directories.

    ```sh
    $ terragrunt run-all init --terragrunt-working-dir='envs/dev/' -upgrade -reconfigure
    ```

7.  Generates a speculative execution plan. (Optional)

    ```sh
    $ terragrunt run-all plan --terragrunt-working-dir='envs/dev/'
    ```

8.  Creates or updates infrastructure.

    ```sh
    $ terragrunt run-all apply --terragrunt-working-dir='envs/dev/' --terragrunt-non-interactive
    ```

Cleanup
-------

```sh
$ terragrunt run-all destroy --terragrunt-working-dir='envs/dev/' --terragrunt-non-interactive
```
