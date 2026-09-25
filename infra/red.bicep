// Parámetros
param ubicacion string = 'spaincentral'
param nombreVnet string = 'vnet-dzsystem-prod'
param ipAdmin string = '79.145.51.77'

param etiquetas object = {
  project: 'dzsystem'
  environment: 'prod'
  owner: 'david.zafra'
  costCenter: 'it'
}

// NSG de la subred web
resource nsgWeb 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-dzsystem-web'
  location: ubicacion
  tags: etiquetas
  properties: {
    securityRules: [
      {
        name: 'allow-https-inbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          description: 'Permite trafico HTTPS desde Internet'
        }
      }
      {
        name: 'allow-http-inbound'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
          description: 'Permite trafico HTTP desde Internet'
        }
      }
      {
        name: 'allow-ssh-from-admin'
        properties: {
          priority: 120
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: ipAdmin
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
          description: 'Permite SSH solo desde la IP del administrador'
        }
      }
    ]
  }
}

// NSG de la subred de aplicacion
resource nsgApp 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-dzsystem-app'
  location: ubicacion
  tags: etiquetas
  properties: {
    securityRules: [
      {
        name: 'allow-web-to-app'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '10.0.1.0/24'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '8080'
          description: 'Permite trafico desde la subred web'
        }
      }
    ]
  }
}

// NSG de la subred de administracion
resource nsgMgmt 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-dzsystem-mgmt'
  location: ubicacion
  tags: etiquetas
  properties: {
    securityRules: [
      {
        name: 'allow-ssh-from-admin'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: ipAdmin
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
          description: 'Permite SSH solo desde la IP del administrador'
        }
      }
    ]
  }
}

// Red virtual con sus subredes
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: nombreVnet
  location: ubicacion
  tags: etiquetas
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-web'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: {
            id: nsgWeb.id
          }
        }
      }
      {
        name: 'snet-app'
        properties: {
          addressPrefix: '10.0.2.0/24'
          networkSecurityGroup: {
            id: nsgApp.id
          }
        }
      }
      {
        name: 'snet-mgmt'
        properties: {
          addressPrefix: '10.0.3.0/24'
          networkSecurityGroup: {
            id: nsgMgmt.id
          }
        }
      }
    ]
  }
}

// Salidas
output vnetId string = vnet.id
output subnetWebId string = vnet.properties.subnets[0].id