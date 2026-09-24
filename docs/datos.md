# Datos: almacenamiento y base de datos

En esta fase añadí dos cosas al proyecto: un sitio donde guardar archivos y una base de
datos conectada a la aplicación web.

## Almacenamiento de archivos

Una cuenta de almacenamiento (`stdzsystemprod2026`) hace de disco duro en la nube. Ahí se
suben archivos sueltos: documentos, imágenes, copias de seguridad.

La creé con dos protecciones que Azure no pone por defecto:

- **Nada puede hacerse público.** Aunque alguien lo intente, los archivos no serán
  accesibles desde internet. La mayoría de filtraciones de datos en la nube vienen de
  tener esto mal configurado.
- **Solo conexiones cifradas modernas.** Se rechazan las versiones antiguas del cifrado.

Para subir archivos me identifico con mi usuario de Azure, no con la contraseña maestra de
la cuenta. Aquí aprendí algo que no es obvio: **ser administrador del recurso no te
permite ver lo que hay dentro**. Son dos permisos distintos, y tuve que darme el segundo a
mí mismo. Está hecho a propósito, para que quien gestiona la infraestructura no tenga
acceso automático a datos confidenciales.

## Base de datos

Un servidor MySQL (`mysql-dzsystem-dz2026`) donde la aplicación guardará su información.

Lo creé **cerrado a internet**. Por defecto nadie puede conectarse, ni siquiera yo.
Después abrí el acceso solo para dos casos: la aplicación web y mi ordenador. Lo habitual
es hacer lo contrario, dejarlo abierto y confiar en la contraseña, y es un riesgo
innecesario.

## Conectar la aplicación con la base de datos

La contraseña **no está escrita en el código**. Si lo estuviera, acabaría publicada en
GitHub, que es uno de los fallos de seguridad más comunes que existen. En su lugar, las
credenciales se guardan en la configuración de la aplicación y el código las pide cuando
las necesita. Así el repositorio puede ser público sin ningún riesgo.

El primer intento de conexión falló con este mensaje:

> Connections using insecure transport are prohibited

Azure obliga a que el tráfico con la base de datos vaya cifrado, y mi código intentaba
conectarse sin cifrar. Lo corregí y ahora la conexión funciona y viaja protegida.

## Qué mejoraría

La contraseña sigue guardada en la configuración de la aplicación. Lo ideal sería moverla
a **Azure Key Vault**, un servicio pensado para custodiar secretos, donde queda cifrada y
se registra cada acceso.