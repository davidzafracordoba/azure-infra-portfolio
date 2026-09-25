# Monitorización y copias de seguridad

Hasta ahora la infraestructura estaba montada, pero si algo fallaba no me enteraba y si
algo se perdía no había vuelta atrás. Esta fase resuelve las dos cosas.

## Recoger los datos

Todo pasa por un **Log Analytics Workspace** (`log-dzsystem-prod`), que hace de almacén
central. Los recursos generan información constantemente, pero se pierde si nadie la
guarda, así que hay que conectarlos a él uno a uno.

Conecté la aplicación web (registros de cada visita y métricas de rendimiento) y la base
de datos (métricas de CPU, memoria y conexiones). Ahora, si alguien dice que la web va
lenta, puedo mirar los datos en lugar de suponer.

## Avisar cuando algo va mal

Nadie está mirando gráficas todo el día, así que configuré dos alertas que envían un
correo:

- **CPU de MySQL por encima del 80%** durante 5 minutos.
- **Más de 5 errores de servidor (5xx)** en la web en 5 minutos.

Las dos miran promedios en una ventana de tiempo, no valores instantáneos. Es a propósito:
una alerta que salta por cada pico puntual acaba ignorándose, y entonces no sirve de nada.
Los errores 4xx no generan aviso porque suelen ser culpa del usuario, como escribir mal
una URL.

## Copias de seguridad

Cada recurso estaba en una situación distinta:

**La base de datos** ya tenía copias automáticas de Azure, con 7 días de retención y
posibilidad de restaurar a cualquier momento de esa semana. No hubo que hacer nada.

**El almacenamiento** guarda tres copias de cada archivo, pero eso protege del fallo de un
disco, no de un borrado: si borras algo, desaparece de las tres. Redundancia y copia de
seguridad no son lo mismo.

**La máquina virtual** no tenía nada. Si se corrompe el disco, se pierde.

Intenté protegerla con Azure Backup, pero la máquina no aparecía como elegible ni desde la
línea de comandos ni desde el portal, probablemente por una limitación de la región con
máquinas en zona de disponibilidad. Como alternativa creé una **instantánea del disco**,
que es una copia puntual desde la que se puede reconstruir la máquina.

Es una solución más limitada: hay que lanzarla a mano, no tiene política de retención y
vive en la misma región. Para este proyecto vale, pero en un entorno real habría que
resolver el problema con Azure Backup o replicar las instantáneas a otra región.

## Qué mejoraría

- Redundancia geográfica en las copias de MySQL, que solo puede activarse al crear el
  servidor.
- Alertas sobre el espacio de almacenamiento antes de que se agote.
- Copias automáticas de la VM, en lugar de instantáneas manuales.