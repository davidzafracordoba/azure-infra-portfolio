targetScope = 'subscription'

// Parámetros
param ubicacion string = 'spaincentral'
param ipAdmin string = '79.145.51.77'

@secure()
param passwordBaseDatos string

// Nombres de los grupos de recursos
var rgRed = 'rg-dzsystem-network-prod'
var rgComputo = 'rg-dzsystem-compute-prod'
var rgApp = 'rg-dzsystem-app-prod'

// Modulo de red
module red 'red.bicep' = {
  name: 'despliegue-red'
  scope: resourceGroup(rgRed)
  params: {
    ubicacion: ubicacion
    ipAdmin: ipAdmin
  }
}

// Modulo de almacenamiento
module almacenamiento 'almacenamiento.bicep' = {
  name: 'despliegue-almacenamiento'
  scope: resourceGroup(rgApp)
  params: {
    ubicacion: ubicacion
  }
}

// Modulo de base de datos
module baseDatos 'basedatos.bicep' = {
  name: 'despliegue-basedatos'
  scope: resourceGroup(rgApp)
  params: {
    ubicacion: ubicacion
    ipAdmin: ipAdmin
    passwordAdmin: passwordBaseDatos
  }
}

// Modulo de aplicacion
module aplicacion 'aplicacion.bicep' = {
  name: 'despliegue-aplicacion'
  scope: resourceGroup(rgApp)
  params: {
    ubicacion: ubicacion
    passwordBaseDatos: passwordBaseDatos
  }
}

// Modulo de maquina virtual
module maquinaVirtual 'maquinavirtual.bicep' = {
  name: 'despliegue-vm'
  scope: resourceGroup(rgComputo)
  params: {
    ubicacion: ubicacion
    subnetId: red.outputs.subnetWebId
  }
}

// Salidas
output urlAplicacion string = aplicacion.outputs.urlApp
output ipVm string = maquinaVirtual.outputs.ipPublicaVm