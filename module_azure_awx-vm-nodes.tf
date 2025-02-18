# ---------------------------------------------------------------------------------------------------------------------
module "awx_node" {
  source    = "git::ssh://git@github.com/NTT-DPA-Client-Connectivity/terraform-module-azure-virtual-machine.git"
  providers = { azurerm = azurerm.NTT-TPS-vNext-Prod }

  ##  Network Location (Existing)
  virtual_network_resource_group_name = "managed_network-sdu_eu_vnext-rg"
  virtual_network_vnet_name           = "managed_network-sdu_eu_vnext-vnet"
  virtual_network_subnet_name         = "managed_network-sdu_eu_vnext_manage-subnet"


  ##  Resource Group
  resource_group_name     = "vnext-vm_automation"
  resource_group_location = "West Europe"

  ##  Storage Account
  storage_account = module.storage_account_au.storage_account

  ##  Linux Nodes
  linux_vm_count           = 2
  linux_vm_name_prefix     = "pzweeuAWXNnxt"
  linux_vm_username        = "devopsadmin"
  linux_vm_password        = module.vault_awx_node.secrets.admin.data["password"]
  linux_vm_ssh_public_key  = module.vault_awx_node.secrets.ssh.data["azure_dev_id_rsa.pub"]
  linux_vm_size            = "Standard_F4s_v2"
  linux_vm_os_disk_type    = "Standard_LRS"
  linux_vm_updates_enabled = true

  linux_vm_source_image_reference = {
    publisher = "Redhat"
    offer     = "RHEL"
    sku       = "8_6"
    version   = "latest"
  }

}

# ---------------------------------------------------------------------------------------------------------------------
module "vault_awx_node" {
  source = "git::ssh://git@github.com/NTT-DPA-Client-Connectivity/terraform-module-vault-secrets.git"

  read_secrets = {
    ssh     = "Certificates/ssh_public_keys"
    admin   = "vNext/common/local_administrator"
  }

}
