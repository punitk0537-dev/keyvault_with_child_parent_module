data "azurerm_subnet" "subnet" {
    for_each = var.virtual_machine
    name= each.value.subnet_name
    virtual_network_name = each.value.virtual_network_name
    resource_group_name = each.value.resource_group_name

}

resource "azurerm_network_interface" "nic" {
    for_each = var.virtual_machine
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

data "azurerm_key_vault" "kv" {
  name                = "punit-kv"
  resource_group_name = "punit-kv"
}
data "azurerm_key_vault_secret" "username" {
  name         = "vm-username"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "password" {
  name         = "vm-pasword"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_linux_virtual_machine" "vm" {
    for_each = var.virtual_machine
  name                = each.value.vm_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.vm_size 

#   size ="Standard_D2s_vs"

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]
disable_password_authentication = false
 admin_username = data.azurerm_key_vault_secret.username.value
 admin_password = data.azurerm_key_vault_secret.password.value

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}