variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-terraform-app-sc"
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "North Europe"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "App-React-SC"
  type        = string
  default     = "miniprojet"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "MiniProjetCloud"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B1s"
}

variable "vm_admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "storage_account_tier" {
  description = "Storage account tier (Standard or Premium)"
  type        = string
  default     = "Standard"
}

/* Etapes 2 */

variable "storage_replication_type" {
  description = "Storage account replication type (LRS, GRS, RAGRS, ZRS)"
  type        = string
  default     = "LRS"
}

variable "enable_cdn" {
  description = "Enable CDN for static files"
  type        = bool
  default     = true
}

variable "cdn_sku" {
  description = "CDN SKU (Standard_Microsoft, Standard_Akamai, Standard_Verizon, Premium_Verizon)"
  type        = string
  default     = "Standard_Microsoft"
}

variable "logs_retention_days" {
  description = "Number of days to retain logs before deletion"
  type        = number
  default     = 365
}

variable "backup_retention_days" {
  description = "Number of days to retain backups before deletion"
  type        = number
  default     = 2555  # 7 ans
}

# MySQL Database Variables
variable "mysql_admin_username" {
  description = "MySQL administrator username"
  type        = string
  # Valeur fournie via terraform.tfvars
}

variable "mysql_admin_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true
  # Valeur fournie via terraform.tfvars (SENSIBLE)
}

variable "mysql_sku_name" {
  description = "MySQL SKU name (B_Standard_B1ms, GP_Standard_D2s_v3, etc.)"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0.21"
}

variable "mysql_storage_size_gb" {
  description = "MySQL storage size in GB"
  type        = number
  default     = 20
}

variable "mysql_backup_retention_days" {
  description = "MySQL backup retention days"
  type        = number
  default     = 7
}

variable "mysql_database_name" {
  description = "Name of the MySQL database"
  type        = string
  default     = "appdb"
} 