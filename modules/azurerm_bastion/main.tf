# resource "azurerm_subnet" "bastion" {
#     for_each = var.bastion
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["192.168.1.224/27"]
# }

data "azurerm_subnet" "subnet"{
    for_each = var.bastion
    name = each.value.subnet_name
    virtual_network_name = each.value.virtual_network_name
    resource_group_name = each.value.resource_group_name
}

resource "azurerm_public_ip" "public_ip" {
    for_each = var.bastion
  name                = each.value.public_ip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
    for_each = var.bastion
  name                = each.value.bastion_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.subnet[each.key].id
    public_ip_address_id = azurerm_public_ip.public_ip[each.key].id
  }
}