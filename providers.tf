
/************************************************************************************************************************************************************
# Fichero en el que se deben declarar los proveedores cloud (Azure, AWS,Google Cloud, OpenStack, etc.)
************************************************************************************************************************************************************/

#################################################################################################### 
# Configuración del proveedor Microsoft Azure
####################################################################################################

provider "azurerm" {
  subscription_id = "${var.subscription_id}" // Nombre de la suscripción en la que se realizará el despliegue - PoCs (Dev/Test Labs)
  client_id       = "${var.client_id}" // Identificador de la aplicación (service principal) creada en Azure Active Directory
  client_secret   = "${var.client_secret}" // Clave asignada para el usuario que realizará el despliegue en el proveedor Cloud
  tenant_id       = "${var.tenant_id}" // Tenant de Azure (Grupo Mediaset)
  
  
}

