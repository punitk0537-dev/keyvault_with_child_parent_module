module "rgs" {

  source = "../../modules/azurerm_rg"
  rgs    = {
    dev={
        name="dev-rg"
        location="centralindia"
         
    }
  }
}
module "vnets" {
  depends_on = [module.rgs]
  source     = "../../modules/azurerm_vnet"

  vnets = {
    dev ={
        name= "dev-vnet"
        location= "centralindia"
        resource_group_name = "dev-rg"
        address_space = ["10.0.0.0/16"]
    }
  }
}


module "subnets" {
  depends_on = [module.vnets]
  source     = "../../modules/azurerm_subnet"

  subnets = {
    dev ={
        name = "dev-sunet"
        resource_group_name = "dev-rg"
        virtual_network_name = "dev-vnet"
        address_prefixes = ["10.0.1.0/24"]
    }

      BastionSubnet ={
        name = "AzureBastionSubnet"
        resource_group_name = "dev-rg"
        virtual_network_name = "dev-vnet"
        address_prefixes = ["10.0.2.0/24"]
    }
  }
}
module "bastion" {
    depends_on = [ module.subnets ]
    source = "../../modules/azurerm_bastion"
    bastion = {
        dev = {
            bastion_name = "dev-bastion"
            resource_group_name = "dev-rg"
            location = "centralindia"
            virtual_network_name = "dev-vnet"
            subnet_name = "AzureBastionSubnet"
            public_ip_name = "dev-bastion-pip"
            
        }
    }
  
}
module "vm" {
    depends_on = [ module.subnets ]
    source = "../../modules/azurerm_vm"
    virtual_machine = {
        dev ={
            
             virtual_network_name="dev-vnet"
             resource_group_name ="dev-rg"
             subnet_name = "dev-sunet"
             nic_name = "dev-nic"
             location = "centralindia"
             vm_size = "Standard_B2ats_v2"
             vm_name ="punit-dev-vm"

        }
    }


  
}
