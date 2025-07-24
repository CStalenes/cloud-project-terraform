# Create Resource Group
resource "azurerm_resource_group" "rgAppSC" {
  name     = "rg-terraform-app-sc"
  location = "North Europe"
  tags     = {
    environment = "dev"
    project     = "terraform-app-sc"
  }
}

# Create Storage Account
resource "azurerm_storage_account" "storageAppSC" {
  name                     = "stappsc"
  resource_group_name      = azurerm_resource_group.rgAppSC.name
  location                 = azurerm_resource_group.rgAppSC.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
  
  tags = var.tags
}

# Create Storage Container for public static files (CSS, JS, images)
resource "azurerm_storage_container" "publicFiles" {
  name                  = "public-files"
  storage_account_name  = azurerm_storage_account.storageAppSC.name
  container_access_type = "blob"  # Accès public en lecture seule
}

# Create Storage Container for private user uploads
resource "azurerm_storage_container" "privateFiles" {
  name                  = "private-files"
  storage_account_name  = azurerm_storage_account.storageAppSC.name
  container_access_type = "private"  # Accès privé uniquement
}

# Create Storage Container for application logs
resource "azurerm_storage_container" "appLogs" {
  name                  = "app-logs"
  storage_account_name  = azurerm_storage_account.storageAppSC.name
  container_access_type = "private"  # Accès privé uniquement
}

# Create Storage Container for backup files
resource "azurerm_storage_container" "backupFiles" {
  name                  = "backup-files"
  storage_account_name  = azurerm_storage_account.storageAppSC.name
  container_access_type = "private"  # Accès privé uniquement
}

# Create App Service Plan
resource "azurerm_service_plan" "aspAppSC" {
  name                = "asp-app-sc"
  resource_group_name = azurerm_resource_group.rgAppSC.name
  location            = azurerm_resource_group.rgAppSC.location
  os_type             = "Linux"
  sku_name            = "B1"
  
  tags = var.tags
}

# Create App Service for frontend
resource "azurerm_linux_web_app" "frontendAppSC" {
  name                = "frontend-app-sc"
  resource_group_name = azurerm_resource_group.rgAppSC.name
  location            = azurerm_resource_group.rgAppSC.location
  service_plan_id     = azurerm_service_plan.aspAppSC.id

  site_config {
    always_on = false
    
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "18-lts"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
  }

  tags = var.tags
}

# Create App Service for backend
resource "azurerm_linux_web_app" "backendAppSC" {
  name                = "backend-app-sc"
  resource_group_name = azurerm_resource_group.rgAppSC.name
  location            = azurerm_resource_group.rgAppSC.location
  service_plan_id     = azurerm_service_plan.aspAppSC.id

  site_config {
    always_on = false
    
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "18-lts"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
  }

  tags = var.tags
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnetAppSC" {
  name                = "vnet-app-sc"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rgAppSC.location
  resource_group_name = azurerm_resource_group.rgAppSC.name

  tags = var.tags
}

# Create Subnet
resource "azurerm_subnet" "subnetAppSC" {
  name                 = "subnet-app-sc"
  resource_group_name  = azurerm_resource_group.rgAppSC.name
  virtual_network_name = azurerm_virtual_network.vnetAppSC.name
  address_prefixes     = ["10.0.1.0/24"]
  
  service_endpoints = ["Microsoft.Storage"]
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "nsgAppSC" {
  name                = "nsg-app-sc"
  location            = azurerm_resource_group.rgAppSC.location
  resource_group_name = azurerm_resource_group.rgAppSC.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAnyCustom5100-5300Inbound"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["5100-5300"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "Backend-Node"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5170"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Front-React"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5193"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Create Public IP
resource "azurerm_public_ip" "publicIPAppSC" {
  name                = "publicip-app-sc"
  location            = azurerm_resource_group.rgAppSC.location
  resource_group_name = azurerm_resource_group.rgAppSC.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# Create Network Interface
resource "azurerm_network_interface" "nicAppSC" {
  name                = "nic-app-sc"
  location            = azurerm_resource_group.rgAppSC.location
  resource_group_name = azurerm_resource_group.rgAppSC.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetAppSC.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicIPAppSC.id
  }

  tags = var.tags
}

# Associate Network Security Group to the subnet
resource "azurerm_subnet_network_security_group_association" "nsgAssociation" {
  subnet_id                 = azurerm_subnet.subnetAppSC.id
  network_security_group_id = azurerm_network_security_group.nsgAppSC.id
}

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "vmAppSC" {
  name                = "vm-app-sc"
  location            = azurerm_resource_group.rgAppSC.location
  resource_group_name = azurerm_resource_group.rgAppSC.name
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nicAppSC.id,
  ]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(var.ssh_public_key_path)  # Assurez-vous d'avoir une clé SSH
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}

# Create lifecycle management policy for storage account
resource "azurerm_storage_management_policy" "storagePolicy" {
  storage_account_id = azurerm_storage_account.storageAppSC.id

  rule {
    name    = "LogsLifecycleRule"
    enabled = true
    filters {
      prefix_match = ["app-logs/"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = var.logs_retention_days
      }
    }
  }

  rule {
    name    = "BackupLifecycleRule"
    enabled = true
    filters {
      prefix_match = ["backup-files/"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 7
        tier_to_archive_after_days_since_modification_greater_than = 30
        delete_after_days_since_modification_greater_than          = var.backup_retention_days
      }
    }
  }
}

# Create Storage Account Network Rules for enhanced security
resource "azurerm_storage_account_network_rules" "storageNetworkRules" {
  storage_account_id = azurerm_storage_account.storageAppSC.id

  default_action             = "Allow"  # Changez à "Deny" pour plus de sécurité
  ip_rules                   = []  # Ajoutez vos IPs autorisées ici
  virtual_network_subnet_ids = [azurerm_subnet.subnetAppSC.id]
  bypass                     = ["AzureServices"]
}

# Create CDN Profile for static files
resource "azurerm_cdn_profile" "cdnProfile" {
  name                = "cdn-app-sc"
  location            = "Global"
  resource_group_name = azurerm_resource_group.rgAppSC.name
  sku                 = "Standard_Microsoft"

  tags = var.tags
}

# Create CDN Endpoint for public static files
resource "azurerm_cdn_endpoint" "cdnEndpoint" {
  name                = "cdn-endpoint-app-sc"
  profile_name        = azurerm_cdn_profile.cdnProfile.name
  location            = azurerm_cdn_profile.cdnProfile.location
  resource_group_name = azurerm_resource_group.rgAppSC.name

  origin {
    name      = "storage-origin"
    host_name = azurerm_storage_account.storageAppSC.primary_blob_host
  }

  origin_path = "/public-files"

  delivery_rule {
    name  = "CacheStaticFiles"
    order = 1

    url_file_extension_condition {
      operator         = "Contains"
      negate_condition = false
      match_values     = ["css", "js", "png", "jpg", "jpeg", "gif", "svg", "ico"]
    }

    cache_expiration_action {
      behavior = "Override"
      duration = "7.00:00:00"  # 7 jours
    }
  }

  tags = var.tags
}

# Create MySQL Server
resource "azurerm_mysql_flexible_server" "mysqlAppSC" {
  name                = "mysql-app-sc"
  resource_group_name = azurerm_resource_group.rgAppSC.name
  location            = azurerm_resource_group.rgAppSC.location
  
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  
  sku_name   = var.mysql_sku_name
  version    = var.mysql_version
  
  storage {
    size_gb = var.mysql_storage_size_gb
  }

  backup_retention_days = var.mysql_backup_retention_days
  
  # High availability est désactivée pour réduire les coûts en développement
  # Pour la production, décommentez et utilisez "ZoneRedundant" ou "SameZone"
  # high_availability {
  #   mode = "ZoneRedundant"  # ou "SameZone"
  # }

  # Ignorer les changements de zone (non modifiable après création)
  lifecycle {
    ignore_changes = [
      zone
    ]
  }

  tags = var.tags
}

# Create MySQL Database
resource "azurerm_mysql_flexible_database" "appDatabase" {
  name                = var.mysql_database_name
  resource_group_name = azurerm_resource_group.rgAppSC.name
  server_name         = azurerm_mysql_flexible_server.mysqlAppSC.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# Create MySQL Firewall Rule for Azure Services
resource "azurerm_mysql_flexible_server_firewall_rule" "allowAzureServices" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.rgAppSC.name
  server_name         = azurerm_mysql_flexible_server.mysqlAppSC.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Create MySQL Firewall Rule for VM
resource "azurerm_mysql_flexible_server_firewall_rule" "allowVM" {
  name                = "AllowVM"
  resource_group_name = azurerm_resource_group.rgAppSC.name
  server_name         = azurerm_mysql_flexible_server.mysqlAppSC.name
  start_ip_address    = azurerm_public_ip.publicIPAppSC.ip_address
  end_ip_address      = azurerm_public_ip.publicIPAppSC.ip_address
  depends_on          = [azurerm_public_ip.publicIPAppSC]
}

# Create MySQL Firewall Rule for local development (supprimée pour sécurité)
# resource "azurerm_mysql_flexible_server_firewall_rule" "allowDevelopment" {
#   name                = "AllowDevelopment"
#   resource_group_name = azurerm_resource_group.rgAppSC.name
#   server_name         = azurerm_mysql_flexible_server.mysqlAppSC.name
#   start_ip_address    = "VOTRE_IP_PUBLIQUE"     # Remplacez par votre IP spécifique
#   end_ip_address      = "VOTRE_IP_PUBLIQUE"     # Remplacez par votre IP spécifique
# }

# Create MySQL VNet Rule for secure access
resource "azurerm_mysql_flexible_server_configuration" "mysqlConfig" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.rgAppSC.name
  server_name         = azurerm_mysql_flexible_server.mysqlAppSC.name
  value               = "ON"
} 
