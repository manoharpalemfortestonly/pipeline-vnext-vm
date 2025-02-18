# ---------------------------------------------------------------------------------------------------------------------
################################
##      .tfstate Backend      ##
################################
terraform {
  backend "azurerm" {
    tenant_id            = "e3cf3c98-a978-465f-8254-9d541eeea73c"
    subscription_id      = "fad12353-b08b-4a7e-b3d9-a7e7840a6a6b"
    resource_group_name  = "platops_tools_storage-rg"
    storage_account_name = "platopstools"
    container_name       = "tfstate-automationplatform"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
################################
##       Vault Providers      ##
################################
provider "vault" {
  address = var.VAULT_ADDRESS
  token   = var.VAULT_TOKEN
}

module "vault" {
  source = "git::ssh://git@github.com/NTT-DPA-Client-Connectivity/terraform-module-vault-secrets.git"
  read_secrets = {
    azure = "vNext/service_accounts/azure"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
################################
##       Azure Providers      ##
################################
provider "azurerm" {
  alias = "NTT-TPS-vNext-Prod"
  features {}
  client_id       = module.vault.secrets.azure.data["ARM_CLIENT_ID"]
  client_secret   = module.vault.secrets.azure.data["ARM_CLIENT_SECRET"]
  tenant_id       = module.vault.secrets.azure.data["ARM_TENANT_ID"]
  subscription_id = "9243a991-ef89-4f46-b064-496c8a8a6bd8"
}
