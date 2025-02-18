# ---------------------------------------------------------------------------------------------------------------------
module "storage_account_au" {
  source    = "git::ssh://git@github.com/NTT-DPA-Client-Connectivity/terraform-module-azure-storage-account.git"
  providers = { azurerm = azurerm.NTT-TPS-vNext-Prod }

  ##  Location
  resource_group = module.awx_node.resource_group

  ##  Storage Account
  storage_account_name = "nxtstorageau"
  storage_account_tier = "Standard"
  storage_account_kind = "StorageV2"
  storage_account_tags = {
    "Resolver Group" = ""
    "Environment"    = "Production"
    "Service"        = "Storage"
  }

  ##  Private Endpoint
  enable_storage_private_endpoint_file   = true
  enable_storage_private_endpoint_blob   = true
  storage_private_endpoint_subnet_id     = module.awx_node.subnet.id
  storage_account_network_default_action = "Allow"

  #### Register to Private DNS Zone Groups
  enable_storage_private_dns_zone_groups = true
  private_dns_resources = {
    privatelink_file = module.vault_storage_au.secrets.privatelink_file.data
    privatelink_blob = module.vault_storage_au.secrets.privatelink_blob.data
  }

}

# ---------------------------------------------------------------------------------------------------------------------
module "vault_storage_au" {
  source = "git::ssh://git@github.com/NTT-DPA-Client-Connectivity/terraform-module-vault-secrets.git"
  read_secrets = {
    privatelink_file = "PlatformOps/azure/TF_private_dns/privatelink_file"
    privatelink_blob = "PlatformOps/azure/TF_private_dns/privatelink_blob"
  }
}
