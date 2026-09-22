# Convenciones de DZSystem en Azure

## Nomenclatura
Formato: `<tipo>-<empresa>-<función>-<entorno>`, siempre en minúsculas.

| Prefijo | Tipo de recurso |

| rg | Grupo de recursos |
| vnet | Red virtual |
| snet | Subred |
| nsg | Grupo de seguridad de red |
| vm | Máquina virtual |
| st | Cuenta de almacenamiento |

## Etiquetas obligatorias
| Etiqueta | Descripción |

| project | Nombre del proyecto (dzsystem) |
| environment | Entorno (prod, dev) |
| owner | Responsable del recurso |
| costCenter | Departamento que asume el coste (it, dev, finance) |

## Grupos de recursos
| Nombre | Contenido | costCenter |

| rg-dzsystem-network-prod | Redes, subredes y NSG | it |
| rg-dzsystem-compute-prod | Máquinas virtuales | it |
| rg-dzsystem-app-prod | Aplicación y base de datos | dev |
| rg-dzsystem-monitor-prod | Monitorización y logs | it |