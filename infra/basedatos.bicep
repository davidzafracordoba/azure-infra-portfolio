// Parámetros
param ubicacion string = 'spaincentral'
param nombreServidor string = 'mysql-dzsystem-dz2026'
param usuarioAdmin string = 'dzadmin'
param ipAdmin string = '79.145.51.77'

@secure()
param passwordAdmin string

param etiquetas object = {
  project: 'dzsystem'
  environment: 'prod'
  owner: 'david.zafra'
  costCenter: 'dev'
}

// Servidor MySQL
resource mysql 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' = {
  name: nombreServidor
  location: ubicacion
  tags: etiquetas
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    version: '8.0.21'
    administratorLogin: usuarioAdmin
    administratorLoginPassword: passwordAdmin
    storage: {
      storageSizeGB: 32
      autoGrow: 'Enabled'
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    network: {
      publicNetworkAccess: 'Enabled'
    }
  }
}

// Base de datos de la aplicacion
resource baseDatos 'Microsoft.DBforMySQL/flexibleServers/databases@2023-12-30' = {
  parent: mysql
  name: 'dzsystem_app'
  properties: {
    charset: 'utf8mb4'
    collation: 'utf8mb4_0900_ai_ci'
  }
}

// Regla: permitir servicios de Azure
resource reglaAzure 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2023-12-30' = {
  parent: mysql
  name: 'allow-azure-services'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// Regla: permitir IP del administrador
resource reglaAdmin 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2023-12-30' = {
  parent: mysql
  name: 'allow-admin-ip'
  properties: {
    startIpAddress: ipAdmin
    endIpAddress: ipAdmin
  }
}

// Salidas
output servidorFqdn string = mysql.properties.fullyQualifiedDomainName