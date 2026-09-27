# Infraestructura como código y despliegue automático

Hasta aquí había creado todo con comandos sueltos. Funciona, pero si quisiera montar el
mismo entorno otra vez tendría que repetir cincuenta comandos en el orden correcto y sin
equivocarme. Esta fase resuelve eso.

## Las plantillas

Toda la infraestructura está descrita en archivos Bicep dentro de `infra/`: la red con sus
subredes y cortafuegos, el almacenamiento, la base de datos, la aplicación web y la
máquina virtual. Un archivo `main.bicep` los une y despliega todo con un solo comando.

La diferencia con los comandos es que aquí no describes los pasos, describes el resultado.
Azure compara lo que hay con lo que pides y aplica solo las diferencias. Si alguien cambia
algo a mano en el portal, volver a desplegar lo devuelve a su sitio.

## Lo que me enseñó el `what-if`

Antes de aplicar nada, Bicep permite previsualizar los cambios. Lo usé en cada plantilla y
evitó tres problemas que no habría visto de otra forma:

- **La primera versión de la red borraba los tres cortafuegos**, porque mi archivo describía
  las subredes sin ellos. Bicep aplica lo que está escrito: lo que no aparece, se elimina.
- **La plantilla de MySQL desactivaba el crecimiento automático** del almacenamiento y
  cambiaba la intercalación de la base de datos. Dos cambios silenciosos que habrían dado
  problemas más adelante.
- **La de la máquina virtual renombraba la configuración de red**, lo que habría recreado
  la tarjeta y perdido su IP privada.

## Lo que el `what-if` no detecta

Al desplegar la máquina virtual falló con este error:

> Changing property 'linuxConfiguration.ssh.publicKeys' is not allowed

Las claves SSH de una VM son inmutables: solo se pueden definir al crearla. El `what-if`
predice cambios de configuración, pero no sabe qué propiedades Azure permite modificar.

De aquí sale la conclusión más útil de la fase: **la infraestructura como código se aplica
desde el principio de un proyecto, no a posteriori**. Traducir una infraestructura que ya
existe saca a la luz este tipo de fricciones.

## Despliegue automático

El repositorio tiene un flujo de GitHub Actions que se dispara al subir cambios en
`infra/`. Primero valida las plantillas y previsualiza los cambios; solo si eso pasa,
despliega.

Para que GitHub pueda desplegar en Azure usé **autenticación federada**, no una contraseña.
Azure confía en los tokens que emite GitHub para este repositorio y esta rama concretos, así
que no existe ningún secreto que pueda filtrarse. La identidad tiene rol Contributor, no
Owner: puede crear recursos pero no conceder permisos a nadie.

El primer intento falló porque el identificador que envía GitHub incluye unos números
internos del usuario y del repositorio que no aparecían en la credencial registrada. Se
resolvió añadiendo una credencial con ese identificador exacto.