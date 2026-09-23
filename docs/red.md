# Diseño de red de DZSystem

## Red virtual
| Recurso | Valor |

| Nombre | vnet-dzsystem-prod |
| Espacio de direcciones | 10.0.0.0/16 |
| Región | Spain Central |

## Subredes
| Subred | Rango | NSG asociado | Función |

| snet-web | 10.0.1.0/24 | nsg-dzsystem-web | Servidores web expuestos a Internet |
| snet-app | 10.0.2.0/24 | nsg-dzsystem-app | Aplicación y base de datos, sin acceso público |
| snet-mgmt | 10.0.3.0/24 | nsg-dzsystem-mgmt | Administración y acceso remoto |

> Azure reserva 5 direcciones por subred, por lo que cada /24 ofrece 251 direcciones utilizables.

## Reglas de seguridad
### nsg-dzsystem-web
| Regla | Prioridad | Puerto | Origen | Acción |

| allow-https-inbound | 100 | 443 | Internet | Allow |
| allow-http-inbound | 110 | 80 | Internet | Allow |

### nsg-dzsystem-app
| Regla | Prioridad | Puerto | Origen | Acción |

| allow-web-to-app | 100 | 8080 | 10.0.1.0/24 | Allow |

### nsg-dzsystem-mgmt
| Regla | Prioridad | Puerto | Origen | Acción |

| allow-ssh-from-admin | 100 | 22 | IP del administrador | Allow |

## Criterios de diseño
- **Segmentación por función:** cada capa en su propia subred para aislar un posible compromiso.
- **Defensa en profundidad:** la subred de aplicación solo acepta tráfico desde la subred web, nunca desde Internet.
- **SSH restringido por origen:** el puerto 22 solo está abierto para la IP del administrador, nunca para Internet.
- **Reglas por defecto de Azure:** todo el tráfico entrante desde Internet está denegado salvo lo permitido explícitamente.

## Mejora pendiente
Sustituir el acceso SSH directo por **Azure Bastion**, que permite administrar las máquinas
sin exponer ningún puerto a Internet. Queda fuera del alcance actual por su coste.