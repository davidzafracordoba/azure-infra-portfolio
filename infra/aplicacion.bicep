// Parámetros
param ubicacion string = 'spaincentral'
param nombrePlan string = 'plan-dzsystem-app'
param nombreApp string = 'app-dzsystem-web-dz2026'
param servidorMysql string = 'mysql-dzsystem-dz2026.mysql.database.azure.com'
param nombreBaseDatos string = 'dzsystem_app'
param usuarioBaseDatos string = 'dzadmin'

@secure()
param passwordBaseDatos string

param etiquetas object = {
  project: 'dzsystem'
  environment: 'prod'
  owner: 'david.zafra'
  costCenter: 'dev'
}

// Plan de App Service
resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: nombrePlan
  location: ubicacion
  tags: etiquetas
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// Aplicacion web
resource app 'Microsoft.Web/sites@2023-12-01' = {
  name: nombreApp
  location: ubicacion
  tags: etiquetas
  kind: 'app,linux'
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'PHP|8.2'
      appSettings: [
        {
          name: 'DB_HOST'
          value: servidorMysql
        }
        {
          name: 'DB_NAME'
          value: nombreBaseDatos
        }
        {
          name: 'DB_USER'
          value: usuarioBaseDatos
        }
        {
          name: 'DB_PASSWORD'
          value: passwordBaseDatos
        }
      ]
    }
  }
}

// Salidas
output urlApp string = 'https://${app.properties.defaultHostName}'