# Infrastructure Azure avec Terraform

Ce projet déploie une infrastructure complète sur Azure comprenant :
- Resource Group
- Storage Account avec 4 conteneurs sécurisés
- App Service Plan
- App Services (frontend/backend)
- Virtual Network et subnet
- Machine virtuelle Ubuntu avec IP publique
- Network Security Group avec règles de sécurité
- CDN pour les fichiers statiques
- Lifecycle management automatique
- Règles de sécurité réseau avancées
- **Base de données MySQL managée** avec sécurité SSL

## 📄 Rapport Mini Projet Cloud

Le PDF ne peut pas être affiché directement sur GitHub, mais vous pouvez le télécharger ici :

👉 [**Télécharger le rapport PDF**](./Rapport_Mini_Projet_Cloud_Stalenes_CORIOLAN.pdf)


## 🔑 Prérequis

### 1. Authentification Azure
```bash
az login
```

### 2. Générer une clé SSH
```bash
# Créer une clé SSH si elle n'existe pas
ssh-keygen -t rsa -b 4096 -C "votre-email@example.com"
# Appuyez sur Entrée pour accepter le chemin par défaut (~/.ssh/id_rsa)
```

### 3. Vérifier la clé SSH
```bash
ls -la ~/.ssh/
# Vous devriez voir id_rsa (clé privée) et id_rsa.pub (clé publique)
```

## 🚀 Déploiement

### 1. Initialiser Terraform
```bash
cd TerraformUse
terraform init
```

### 2. Planifier le déploiement
```bash
terraform plan
```

### 3. Déployer l'infrastructure
```bash
terraform apply
```

### 4. Obtenir les informations de connexion
```bash
terraform output vm_ssh_connection
terraform output cdn_endpoint_url
terraform output storage_blob_endpoints
terraform output mysql_server_fqdn
terraform output mysql_connection_string
```

## 📋 Ressources créées

- **Resource Group** : `rg-terraform-app-sc`
- **Storage Account** : `stappsc`
- **Blob Containers** :
  - `public-files` (accès public pour CSS, JS, images)
  - `private-files` (accès privé pour uploads utilisateurs)
  - `app-logs` (logs d'application avec archivage automatique)
  - `backup-files` (sauvegardes avec lifecycle management)
- **App Services** : `frontend-app-sc`, `backend-app-sc`
- **Virtual Machine** : `vm-app-sc` (Ubuntu 20.04)
- **Virtual Network** : `vnet-app-sc` (10.0.0.0/16)
- **Public IP** : `publicip-app-sc`
- **CDN** : `cdn-endpoint-app-sc` (pour les fichiers statiques)
- **MySQL Database** : `mysql-app-sc` (MySQL 8.0.21, SSL requis)
- **Database** : `appdb` (UTF8MB4, prête pour applications)

## 🔒 Sécurité

La VM est configurée avec :
- Authentification par clé SSH uniquement
- Ports ouverts : 22 (SSH), 80 (HTTP), 443 (HTTPS)
- Network Security Group pour filtrer le trafic

Le Blob Storage est sécurisé avec :
- Chiffrement automatique au repos (AES-256)
- Accès différencié par conteneur (public/privé)
- Règles de réseau pour restreindre l'accès
- Lifecycle management pour optimiser les coûts
- CDN pour améliorer les performances

La base de données MySQL est sécurisée avec :
- Connexions SSL/TLS obligatoires
- Authentification par nom d'utilisateur/mot de passe
- Règles de pare-feu configurées
- Sauvegardes automatiques (7 jours)
- Accès restreint depuis Azure Services et la VM

## 🗑️ Nettoyage

Pour supprimer toutes les ressources :
```bash
terraform destroy
```

## 💾 Utilisation du Blob Storage

Consultez le fichier `blob-storage-examples.md` pour des exemples détaillés d'utilisation.

### Accès rapide aux conteneurs :
```bash
# Fichiers publics (CSS, JS, images)
https://stappsc.blob.core.windows.net/public-files/

# Via CDN (plus rapide)
https://cdn-endpoint-app-sc.azureedge.net/

# Upload d'un fichier public
az storage blob upload \
  --account-name stappsc \
  --container-name public-files \
  --name logo.png \
  --file ./logo.png \
  --auth-mode login
```

## 🗄️ Utilisation de MySQL

Consultez le fichier `mysql-examples.md` pour des exemples détaillés d'utilisation.

### Connexion rapide à MySQL :
```bash
# Obtenir les informations de connexion
terraform output mysql_server_fqdn
terraform output mysql_admin_username

# Connexion via client MySQL
mysql -h mysql-app-sc.mysql.database.azure.com \
      -u mysqladmin \
      -p \
      --ssl-mode=REQUIRED \
      appdb

# Exemple de requête
SELECT NOW();
```

### Variables d'environnement pour vos applications :
```bash
DATABASE_HOST=mysql-app-sc.mysql.database.azure.com
DATABASE_USER=mysqladmin
DATABASE_PASSWORD=P@ssw0rd123!
DATABASE_NAME=appdb
DATABASE_PORT=3306
DATABASE_SSL=true
```

## ⚙️ Personnalisation

Vous pouvez modifier les variables dans `variables.tf` :
- `vm_size` : Taille de la VM
- `vm_admin_username` : Nom d'utilisateur admin
- `ssh_public_key_path` : Chemin vers la clé SSH publique
- `location` : Région Azure
- `storage_account_tier` : Niveau de stockage (Standard/Premium)
- `storage_replication_type` : Type de réplication (LRS/GRS/ZRS)
- `enable_cdn` : Activer le CDN
- `logs_retention_days` : Durée de rétention des logs
- `backup_retention_days` : Durée de rétention des sauvegardes
- `mysql_admin_username` : Nom d'utilisateur admin MySQL
- `mysql_admin_password` : Mot de passe admin MySQL
- `mysql_sku_name` : Taille du serveur MySQL (B_Standard_B1ms, GP_Standard_D2s_v3, etc.)
- `mysql_version` : Version MySQL (8.0.21)
- `mysql_storage_size_gb` : Taille du stockage MySQL en GB
- `mysql_database_name` : Nom de la base de données 
