# keyvault_with_child_parent_module

Azure Virtual Machine Deployment Using Terraform
Project Overview

The objective of this project is to deploy an Azure Virtual Machine (VM) using Terraform by following a Parent–Child Module architecture, which promotes modularity, reusability, maintainability, and better infrastructure management.

The VM administrator username and password will be stored manually in Azure Key Vault as secrets. Terraform will retrieve these secrets using Azure Key Vault data blocks and use them during VM creation.

For this project, all infrastructure configuration values will be passed directly through module blocks in the parent main.tf file. We will not use terraform.tfvars at this stage.

Project Objectives
Create and manage Azure infrastructure using Terraform.
Follow a Parent–Child Module architecture as a best practice.
Create separate child modules for each infrastructure component.
Store VM credentials securely in Azure Key Vault.
Retrieve credentials using Terraform data sources.
Deploy an Azure VM with a network interface connected to the appropriate subnet.
Configure Azure Bastion for secure VM access.
Understand module dependencies and resource deployment order.
Prerequisites

Before starting, ensure the following are available:

An active Azure subscription.
Terraform installed on the local machine.
Azure CLI installed and authenticated.
Appropriate Azure permissions to create infrastructure and access Key Vault secrets.
An Azure Key Vault created manually.
Username and password secrets configured in the Key Vault.
Project Architecture

The project follows a Parent–Child Module structure.

Terraform-Azure-VM/
│
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── provider.tf
│       ├── variables.tf
│       └── README.md
│
└── modules/
    ├── azurerm_rg/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── azurerm_vnet/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── azurerm_subnet/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── azurerm_bastion/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── azurerm_vm/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

Parent Module

The parent module is located under environments/dev/. It acts as the main entry point for the Terraform configuration and calls the required child modules.

The parent main.tf file passes the required configuration values directly to each module.

The parent module manages the following components:

Resource Group
Virtual Network
Subnets
Azure Bastion
Virtual Machine

The provider.tf file configures the Azure provider, while variables.tf defines any input variables required by the environment.

Note: For this learning exercise, values will be passed directly through module blocks in main.tf. A separate terraform.tfvars file will not be used.

Child Modules

Each child module is responsible for creating and managing a specific Azure resource or group of related resources.

Child Module	Responsibility
azurerm_rg	Creates the Azure Resource Group.
azurerm_vnet	Creates the Azure Virtual Network.
azurerm_subnet	Creates the required subnets, including the VM subnet and AzureBastionSubnet.
azurerm_bastion	Creates Azure Bastion and its required Public IP configuration.
azurerm_vm	Retrieves Key Vault secrets, creates the Network Interface, and deploys the Linux Virtual Machine.
Azure Key Vault Configuration

Azure Key Vault will be created manually before running the Terraform configuration.

The following secrets will be added to the Key Vault:

Secret Name	Purpose
vm-username	Stores the VM administrator username.
vm-password	Stores the VM administrator password.

The Terraform VM child module will use the following data sources:

azurerm_key_vault to retrieve information about the existing Key Vault.
azurerm_key_vault_secret to retrieve the username and password secrets.

Terraform will then use the retrieved values to configure the VM administrator credentials.

Security consideration: Terraform may store retrieved secret values in its state file. The state file must be protected using appropriate access controls and secure storage. Sensitive variables and outputs alone do not prevent secret values from being stored in state.

Infrastructure Deployment Flow

The infrastructure will be deployed in the following order:

Create the Resource Group.
Create the Virtual Network.
Create the required subnets.
Create Azure Bastion and its Public IP.
Retrieve the credentials from Azure Key Vault.
Create the Network Interface.
Deploy the Linux Virtual Machine.

Terraform module dependencies will be configured to ensure that resources are created in the correct order.

Deployment Steps
Step 1: Create Azure Key Vault Manually

Create an Azure Key Vault in the Azure portal and add the administrator username and password as secrets.

Ensure that the identity used by Terraform has permission to read the secrets.

Step 2: Authenticate to Azure
az login


Verify the active subscription:

az account show


If necessary, select the correct subscription:

az account set --subscription "<SUBSCRIPTION_ID>"

Step 3: Navigate to the Development Environment
cd environments/dev

Step 4: Initialize Terraform
terraform init

Step 5: Validate the Configuration
terraform fmt -recursive
terraform validate

Step 6: Review the Execution Plan
terraform plan


Review the proposed changes before proceeding.

Step 7: Deploy the Infrastructure
terraform apply


Review the plan and confirm the operation when prompted.

Expected Outcome

After successful deployment:

The development Resource Group will be available.
The Virtual Network and required subnets will be created.
Azure Bastion will be configured for secure access.
The Network Interface will be connected to the VM subnet.
A Linux Virtual Machine will be deployed using the credentials retrieved from Azure Key Vault.
Cleanup

To remove the resources managed by Terraform when the exercise is complete:

terraform destroy


Review the proposed deletions before confirming. Resources created manually outside Terraform, such as the Key Vault, may remain and require separate cleanup.

Best Practices Followed
Modular design: Each infrastructure component has its own child module.
Reusability: Child modules can be reused across environments.
Separation of concerns: Environment configuration is separated from resource implementation.
Dependency management: Module dependencies help control deployment order.
Secret management: VM credentials are stored in Azure Key Vault rather than hardcoded in the VM resource configuration.
Infrastructure as Code: Infrastructure can be reviewed, version-controlled, and recreated through Terraform.
Conclusion

This project demonstrates how to deploy an Azure Virtual Machine using Terraform with a reusable Parent–Child Module architecture. It also demonstrates how to integrate Azure Key Vault data sources for retrieving administrator credentials and how to manage dependencies between Azure infrastructure components.

The design provides a foundation for extending the project to additional environments, reusable configurations, and more advanced infrastructure automation practices.
