// Parámetros
param ubicacion string = 'spaincentral'
param nombreVm string = 'vm-dzsystem-web-01'
param usuarioAdmin string = 'azureadmin'
param subnetId string

// La configuracion SSH solo se aplica al crear la maquina virtual.
// Azure no permite modificarla despues, asi que se omite en
// despliegues sobre una VM que ya existe. Se conserva el parametro
// para poder recrear el entorno desde cero.
param clavePublicaSsh string = ''

param etiquetas object = {
  project: 'dzsystem'
  environment: 'prod'
  owner: 'david.zafra'
  costCenter: 'it'
}

// IP publica
resource ipPublica 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: '${nombreVm}PublicIP'
  location: ubicacion
  tags: etiquetas
  sku: {
    name: 'Standard'
  }
  zones: [
    '1'
  ]
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// Tarjeta de red
resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: '${nombreVm}VMNic'
  location: ubicacion
  tags: etiquetas
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfigvm-dzsystem-web-01'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: ipPublica.id
          }
        }
      }
    ]
  }
}

// Maquina virtual
resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: nombreVm
  location: ubicacion
  tags: etiquetas
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ts_v2'
    }
    osProfile: {
      computerName: nombreVm
      adminUsername: usuarioAdmin
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        diskSizeGB: 30
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// Salidas
output ipPublicaVm string = ipPublica.properties.ipAddress