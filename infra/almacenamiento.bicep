// Parámetros
param ubicacion string = 'spaincentral'
param nombreCuenta string = 'stdzsystemprod2026'

param etiquetas object = {
  project: 'dzsystem'
  environment: 'prod'
  owner: 'david.zafra'
  costCenter: 'dev'
}

// Cuenta de almacenamiento
resource almacenamiento 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: nombreCuenta
  location: ubicacion
  tags: etiquetas
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
}

// Servicio de blobs
resource servicioBlob 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: almacenamiento
  name: 'default'
}

// Contenedor
resource contenedor 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: servicioBlob
  name: 'documentos'
  properties: {
    publicAccess: 'None'
  }
}

// Salidas
output cuentaId string = almacenamiento.id
output endpointBlob string = almacenamiento.properties.primaryEndpoints.blob