# ========================================
# OUTPUTS PRINCIPAUX - IPs et URLs
# ========================================

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.rgAppSC.name
}

output "resource_group_location" {
  description = "Location of the created resource group"
  value       = azurerm_resource_group.rgAppSC.location
}

# ========================================
# VM AZURE - IPs et Accès
# ========================================

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.vmAppSC.name
}

output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.publicIPAppSC.ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.nicAppSC.private_ip_address
}

output "vm_ssh_connection" {
  description = "SSH connection string for the virtual machine"
  value       = "ssh ${var.vm_admin_username}@${azurerm_public_ip.publicIPAppSC.ip_address}"
}

output "vm_applications_urls" {
  description = "URLs des applications sur la VM"
  value = {
    backend_health = "http://${azurerm_public_ip.publicIPAppSC.ip_address}:5170/health"
    backend_api    = "http://${azurerm_public_ip.publicIPAppSC.ip_address}:5170/api/products"
    frontend       = "http://${azurerm_public_ip.publicIPAppSC.ip_address}:5193"
    ssh_access     = "ssh ${var.vm_admin_username}@${azurerm_public_ip.publicIPAppSC.ip_address}"
  }
}

# ========================================
# AZURE APP SERVICES - URLs
# ========================================

output "frontend_app_service_name" {
  description = "Name of the frontend app service"
  value       = azurerm_linux_web_app.frontendAppSC.name
}

output "frontend_app_service_url" {
  description = "URL of the frontend app service"
  value       = "https://${azurerm_linux_web_app.frontendAppSC.default_hostname}"
}

output "backend_app_service_name" {
  description = "Name of the backend app service"
  value       = azurerm_linux_web_app.backendAppSC.name
}

output "backend_app_service_url" {
  description = "URL of the backend app service"
  value       = "https://${azurerm_linux_web_app.backendAppSC.default_hostname}"
}

output "app_service_plan_name" {
  description = "Name of the app service plan"
  value       = azurerm_service_plan.aspAppSC.name
}

output "app_services_urls" {
  description = "URLs des Azure App Services"
  value = {
    frontend        = "https://${azurerm_linux_web_app.frontendAppSC.default_hostname}"
    backend         = "https://${azurerm_linux_web_app.backendAppSC.default_hostname}"
    backend_health  = "https://${azurerm_linux_web_app.backendAppSC.default_hostname}/health"
    backend_api     = "https://${azurerm_linux_web_app.backendAppSC.default_hostname}/api/products"
  }
}

# ========================================
# MYSQL DATABASE - Connexion
# ========================================

output "mysql_server_name" {
  description = "Name of the MySQL server"
  value       = azurerm_mysql_flexible_server.mysqlAppSC.name
}

output "mysql_server_fqdn" {
  description = "FQDN of the MySQL server"
  value       = azurerm_mysql_flexible_server.mysqlAppSC.fqdn
}

output "mysql_database_name" {
  description = "Name of the MySQL database"
  value       = azurerm_mysql_flexible_database.appDatabase.name
}

output "mysql_admin_username" {
  description = "MySQL administrator username"
  value       = var.mysql_admin_username
}

output "mysql_connection_string" {
  description = "MySQL connection string"
  value       = "mysql://${var.mysql_admin_username}:${var.mysql_admin_password}@${azurerm_mysql_flexible_server.mysqlAppSC.fqdn}:3306/${azurerm_mysql_flexible_database.appDatabase.name}?sslmode=require"
  sensitive   = true
}

output "mysql_connection_info" {
  description = "Informations de connexion MySQL"
  value = {
    host     = azurerm_mysql_flexible_server.mysqlAppSC.fqdn
    port     = 3306
    database = azurerm_mysql_flexible_database.appDatabase.name
    username = var.mysql_admin_username
    ssl_mode = "require"
  }
}

# ========================================
# STORAGE ACCOUNT - URLs et Accès
# ========================================

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = azurerm_storage_account.storageAppSC.name
}

output "storage_account_primary_access_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.storageAppSC.primary_access_key
  sensitive   = true
}

output "storage_account_connection_string" {
  description = "Connection string for the storage account"
  value       = azurerm_storage_account.storageAppSC.primary_connection_string
  sensitive   = true
}

output "storage_containers" {
  description = "Storage containers created"
  value = {
    public_files  = azurerm_storage_container.publicFiles.name
    private_files = azurerm_storage_container.privateFiles.name
    app_logs     = azurerm_storage_container.appLogs.name
    backup_files = azurerm_storage_container.backupFiles.name
  }
}

output "storage_blob_endpoints" {
  description = "Storage blob endpoints"
  value = {
    primary_blob_endpoint = azurerm_storage_account.storageAppSC.primary_blob_endpoint
    primary_blob_host     = azurerm_storage_account.storageAppSC.primary_blob_host
  }
}

output "storage_urls" {
  description = "URLs des services de stockage"
  value = {
    public_files_direct = "${azurerm_storage_account.storageAppSC.primary_blob_endpoint}public-files/"
    private_files       = "${azurerm_storage_account.storageAppSC.primary_blob_endpoint}private-files/"
    app_logs           = "${azurerm_storage_account.storageAppSC.primary_blob_endpoint}app-logs/"
    backup_files       = "${azurerm_storage_account.storageAppSC.primary_blob_endpoint}backup-files/"
    cdn_endpoint       = "https://${azurerm_cdn_endpoint.cdnEndpoint.fqdn}"
  }
}

# ========================================
# CDN - URLs
# ========================================

output "cdn_endpoint_url" {
  description = "CDN endpoint URL for static files"
  value       = "https://${azurerm_cdn_endpoint.cdnEndpoint.fqdn}"
}

output "public_files_url" {
  description = "Direct URL to public files container"
  value       = "${azurerm_storage_account.storageAppSC.primary_blob_endpoint}public-files/"
}

# ========================================
# CONFIGURATION APPLICATIONS - Variables ENV
# ========================================

output "backend_environment_variables" {
  description = "Variables d'environnement pour le backend"
  value = {
    # Configuration serveur
    PORT                  = "5170"
    NODE_ENV             = "production"
    
    # Configuration MySQL
    DB_HOST              = azurerm_mysql_flexible_server.mysqlAppSC.fqdn
    DB_PORT              = "3306"
    DB_NAME              = azurerm_mysql_flexible_database.appDatabase.name
    DB_USER              = var.mysql_admin_username
    DB_SSL               = "true"
    
    # Configuration CORS
    FRONTEND_URL_VM      = "http://${azurerm_public_ip.publicIPAppSC.ip_address}:5193"
    FRONTEND_URL_AZURE   = "https://${azurerm_linux_web_app.frontendAppSC.default_hostname}"
    
    # Configuration Azure
    WEBSITE_NODE_DEFAULT_VERSION = "18-lts"
  }
  sensitive = false
}

output "frontend_environment_variables" {
  description = "Variables d'environnement pour le frontend"
  value = {
    # Configuration API
    VITE_API_URL_VM      = "http://${azurerm_public_ip.publicIPAppSC.ip_address}:5170"
    VITE_API_URL_AZURE   = "https://${azurerm_linux_web_app.backendAppSC.default_hostname}"
    
    # Configuration CDN
    VITE_CDN_URL         = "https://${azurerm_cdn_endpoint.cdnEndpoint.fqdn}"
    VITE_STORAGE_URL     = azurerm_storage_account.storageAppSC.primary_blob_endpoint
  }
}

# ========================================
# TESTS ET VALIDATION - URLs
# ========================================

output "test_urls" {
  description = "URLs pour tester l'infrastructure"
  value = {
    # Tests VM
    vm_backend_health     = "http://${azurerm_public_ip.publicIPAppSC.ip_address}:5170/health"
    vm_backend_api        = "http://${azurerm_public_ip.publicIPAppSC.ip_address}:5170/api/products"
    vm_frontend           = "http://${azurerm_public_ip.publicIPAppSC.ip_address}:5193"
    vm_ssh                = "ssh ${var.vm_admin_username}@${azurerm_public_ip.publicIPAppSC.ip_address}"
    
    # Tests App Services
    azure_backend_health  = "https://${azurerm_linux_web_app.backendAppSC.default_hostname}/health"
    azure_backend_api     = "https://${azurerm_linux_web_app.backendAppSC.default_hostname}/api/products"
    azure_frontend        = "https://${azurerm_linux_web_app.frontendAppSC.default_hostname}"
    
    # Tests Storage
    cdn_test              = "https://${azurerm_cdn_endpoint.cdnEndpoint.fqdn}"
    storage_public        = "${azurerm_storage_account.storageAppSC.primary_blob_endpoint}public-files/"
  }
}

# ========================================
# COMMANDES UTILES
# ========================================

output "useful_commands" {
  description = "Commandes utiles pour gérer l'infrastructure"
  value = {
    # Connexion VM
    ssh_vm                = "ssh ${var.vm_admin_username}@${azurerm_public_ip.publicIPAppSC.ip_address}"
    
    # MySQL depuis VM
    mysql_connect_vm      = "mysql -h ${azurerm_mysql_flexible_server.mysqlAppSC.fqdn} -u ${var.mysql_admin_username} -p --ssl-mode=REQUIRED ${azurerm_mysql_flexible_database.appDatabase.name}"
    
    # Azure CLI commands
    azure_webapp_logs     = "az webapp log tail --resource-group ${azurerm_resource_group.rgAppSC.name} --name ${azurerm_linux_web_app.backendAppSC.name}"
    azure_mysql_status    = "az mysql flexible-server show --resource-group ${azurerm_resource_group.rgAppSC.name} --name ${azurerm_mysql_flexible_server.mysqlAppSC.name}"
    
    # Tests curl
    curl_vm_health        = "curl http://${azurerm_public_ip.publicIPAppSC.ip_address}:5170/health"
    curl_azure_health     = "curl https://${azurerm_linux_web_app.backendAppSC.default_hostname}/health"
  }
}

# ========================================
# RÉSUMÉ INFRASTRUCTURE
# ========================================

output "infrastructure_summary" {
  description = "Résumé complet de l'infrastructure"
  value = {
    # Informations générales
    resource_group        = azurerm_resource_group.rgAppSC.name
    location             = azurerm_resource_group.rgAppSC.location
    
    # VM Azure
    vm_public_ip         = azurerm_public_ip.publicIPAppSC.ip_address
    vm_private_ip        = azurerm_network_interface.nicAppSC.private_ip_address
    
    # App Services
    frontend_url         = "https://${azurerm_linux_web_app.frontendAppSC.default_hostname}"
    backend_url          = "https://${azurerm_linux_web_app.backendAppSC.default_hostname}"
    
    # Base de données
    mysql_host           = azurerm_mysql_flexible_server.mysqlAppSC.fqdn
    mysql_database       = azurerm_mysql_flexible_database.appDatabase.name
    
    # Stockage
    storage_account      = azurerm_storage_account.storageAppSC.name
    cdn_endpoint         = "https://${azurerm_cdn_endpoint.cdnEndpoint.fqdn}"
    
    # Ports configurés
    backend_port         = "5170"
    frontend_port        = "5193"
    mysql_port           = "3306"
  }
} 