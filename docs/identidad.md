# Modelo de identidad y permisos de DZSystem

## Departamentos y grupos
| Grupo | Departamento | Miembro de ejemplo |

| grp-dzsystem-it | Sistemas | — |
| grp-dzsystem-dev | Desarrollo | Juan García |
| grp-dzsystem-finance | Finanzas | Marta Ruiz |

## Asignaciones RBAC
| Grupo | Rol | Ámbito |

| grp-dzsystem-it | Contributor | rg-dzsystem-network-prod |
| grp-dzsystem-it | Contributor | rg-dzsystem-compute-prod |
| grp-dzsystem-it | Contributor | rg-dzsystem-monitor-prod |
| grp-dzsystem-dev | Contributor | rg-dzsystem-app-prod |
| grp-dzsystem-finance | Cost Management Reader | Suscripción completa |

## Criterios de diseño
- **Mínimo privilegio:** cada grupo recibe solo los permisos que necesita para su función.
- **Permisos a grupos, no a usuarios:** al incorporarse alguien nuevo, basta con añadirlo a su grupo.
- **Contributor en lugar de Owner:** los departamentos gestionan recursos pero no pueden conceder permisos.
- **Ámbito acotado:** los permisos se asignan al grupo de recursos, no a la suscripción, salvo la lectura de costes.
- **Contraseñas temporales:** todos los usuarios deben cambiarla en el primer inicio de sesión.