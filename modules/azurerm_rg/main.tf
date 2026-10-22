resource "azurerm_resource_group" "rgs" {
    for_each = var.rgs
  name     = each.value.name
  location = each.value.location
}

# resource "azurerm_resource_group" "rgs" {
#     for_each=var.rgs
#   name     = each.value.rg_name
#   location = each.value.rg_location
# }
