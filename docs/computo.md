# Cómputo: máquina virtual vs App Service

Desplegué la misma web de dos formas para comparar.

## Máquina virtual

`vm-dzsystem-web-01`, Ubuntu 22.04 en la subred `snet-web`, acceso SSH por clave
restringido a mi IP y Nginx sirviendo una página estática.

Dos problemas que me encontré:

- **El tamaño B1s no estaba disponible en Spain Central.** Con `az vm list-skus` busqué
  alternativas y usé un `Standard_B2ts_v2` en la zona 1.
- **`az vm create` crea un NSG que no pides**, asociado a la tarjeta de red y con solo el
  puerto 22 abierto. Por eso el SSH iba y la web no. En Azure el tráfico pasa dos filtros:
  el de la subred y el de la NIC. Lo borré para centralizar la seguridad en la subred.

El mantenimiento es mío: parches, claves y apagarla cuando no la uso.

## App Service

Plan gratuito F1, PHP 8.2 y despliegue por ZIP. Sin sistema operativo que mantener y con
HTTPS incluido. Lo único que configuré a mano fue forzar HTTPS, porque por defecto también
acepta tráfico sin cifrar.

## Conclusión

La VM da control total y hace falta cuando tienes software antiguo o necesitas tocar el
sistema. App Service se lleva cualquier web estándar con mucho menos trabajo. Para esta
web, App Service gana.

## Costes

La VM se para con `az vm deallocate`, no con `stop`. Con `stop` Azure sigue cobrando el
cómputo porque mantiene el hardware reservado.