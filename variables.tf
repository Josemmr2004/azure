# Variables de entrada
####################################################################################################

# Proveedor 

variable "subscription_id" {
  description = "Nombre de la suscripción en la que se realizará el despliegue"
  type        = "string"
  default     = ""
}

variable "client_id" {
  description = "Identificador de la aplicación (service principal name) creada en Azure Active Directory"
  type        = "string"
  default     = ""
}

variable "client_secret" {
  description = "Clave asignada para el usuario que realizará el despliegue en el proveedor de servicios cloud"
  type        = "string"
  default     = ""
}

variable "tenant_id" {
  description = "Identificador único del Tenant de Azure del Grupo Mediaset"
  type        = "string"
  default     = ""
}



