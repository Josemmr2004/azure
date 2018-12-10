
resource "azurerm_resource_group" "test" {
  name     = "euw-mes-sc-jmmarentes-pocs"
  location = "West US"
}


resource "azurerm_network_security_group" "test" {
  name                = "SG01"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

}


resource "azurerm_virtual_network" "test" {
  name                = "virtualNetwork01"
  resource_group_name = "${azurerm_resource_group.test.name}"
  address_space       = ["10.190.0.0/16"]
  location            = "West US"
  dns_servers         = ["10.100.80.111", "10.100.80.112"]
  
  }

resource "azurerm_subnet" "test1" {
  name           = "subnet1"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
    address_prefix = "10.190.1.0/24"
 
}
resource "azurerm_subnet" "test2" {
  name           = "subnet2"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
    address_prefix = "10.190.2.0/24"
  
  }

# maquina virtual 1
variable "prefix" {
  default = "Mia"
}


resource "azurerm_network_interface" "nic1" {
  name                = "${var.prefix}-nic1"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.test1.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "1" {
  name                  = "${var.prefix}-vm"
  location              = "${azurerm_resource_group.test.location}"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  network_interface_ids = ["${azurerm_network_interface.nic1.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1_machine1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }
}
# maquina virtual 2

resource "azurerm_network_interface" "nic2" {
  name                = "${var.prefix}-nic2"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = "${azurerm_subnet.test2.id}"
    private_ip_address_allocation = "dynamic"
  }
}


resource "azurerm_virtual_machine" "2" {
  name                  = "${var.prefix}-vm1"
  location              = "${azurerm_resource_group.test.location}"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  network_interface_ids = ["${azurerm_network_interface.nic2.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1_machine2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }
  }
  
########################################################################
#resource "azurerm_resource_group" "test3" {
#  name     = "test"
#  location = "West US"
#}

#resource "azurerm_virtual_network" "test3" {
#  name                = "test"
#  location            = "${azurerm_resource_group.test3.location}"
#  resource_group_name = "${azurerm_resource_group.test3.name}"
#  address_space       = ["10.0.0.0/16"]
#}


resource "azurerm_subnet" "test3" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.190.3.0/24"
}


resource "azurerm_public_ip" "test3" {
  name                = "ip_publica"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  public_ip_address_allocation = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "test3" {
  name                = "test"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

    ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.test3.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.test3.id}"
 }

  vpn_client_configuration {
    address_space = ["10.100.200.0/24"]
}
}
resource "azurerm_local_network_gateway" "home" {
  name                = "home"
  resource_group_name = "${azurerm_resource_group.test.name}"
  location            = "${azurerm_resource_group.test.location}"
  gateway_address     = "5.40.40.60"
  address_space       = ["10.100.200.0/24"]
 # type                       = "IPsec"
 # virtual_network_gateway_id = "${azurerm_virtual_network_gateway.test3.id}"
 # local_network_gateway_id   = "${azurerm_local_network_gateway.home.id}"
 #
 # shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"

}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                = "onpremise"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  type                       = "IPsec"
  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.test3.id}"
  local_network_gateway_id   = "${azurerm_local_network_gateway.home.id}"

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}
#
#
