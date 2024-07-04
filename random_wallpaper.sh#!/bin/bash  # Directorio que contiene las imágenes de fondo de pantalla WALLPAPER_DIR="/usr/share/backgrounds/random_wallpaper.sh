#!/bin/bash

# sudo apt install feh

# Directorio que contiene las imágenes de fondo de pantalla
WALLPAPER_DIR="/usr/share/backgrounds"

# Seleccionar una imagen aleatoria del directorio
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Configurar la imagen seleccionada como fondo de pantalla usando feh
feh --bg-scale "$WALLPAPER"

```
    Ejecutar el Script al Inicio:

    Para ejecutar el script automáticamente al iniciar sesión en Cinnamon, sigue estos pasos:
        Abre la configuración del sistema y navega a Aplicaciones al inicio.
        Haz clic en Añadir.
        Completa los campos con la siguiente información:
            Nombre: Fondo de pantalla aleatorio
            Comando: /ruta/completa/al/script/set_random_wallpaper.sh
            Comentario: Establece un fondo de pantalla aleatorio al inicio.
        Guarda la configuración.

Ejecución Manual

Para cambiar el fondo de pantalla manualmente en cualquier momento, simplemente ejecuta el script desde una terminal:

./random_wallpaper.sh

Con estos pasos, tu fondo de pantalla se cambiará aleatoriamente al iniciar sesión  con Cinnamon.
```
