# Terraform Azure

A terraform file to provision VM in Azure and install docker.

## Prerequisites

* Install Terraform https://learn.hashicorp.com/terraform/getting-started/install.html 
* Install Azure Cli https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
* Sign in with Azure Cli https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli?view=azure-cli-latest#sign-in-with-credentials-on-the-command-line

## Initialize Terraform

* Update variable-sample.tf with your username and password to the new VM
* Run `terraform init`
* Run `terraform plan` to create execution plan.
* Run `terraform apply` to actually create VM in your Azure subscription

For more info about Terraform https://www.terraform.io/docs/commands/plan.html 
