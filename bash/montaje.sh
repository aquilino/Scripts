#!/bin/bash

# Función para listar los discos y sus particiones con tamaños
listar_discos_y_particiones() {
    echo "Listado de discos y particiones con tamaños:"
    
    # Usar lsblk para obtener la información de los discos y particiones
    lsblk -o NAME,SIZE,TYPE | grep -E 'disk|part' | while read -r linea; do
        NOMBRE=$(echo $linea | awk '{print $1}')
        TAMANO=$(echo $linea | awk '{print $2}')
        TIPO=$(echo $linea | awk '{print $3}')

        if [ "$TIPO" == "disk" ]; then
            echo "Disco: /dev/$NOMBRE, Tamaño: $TAMANO"
        elif [ "$TIPO" == "part" ]; then
            echo "  Partición: /dev/$NOMBRE, Tamaño: $TAMANO"
        fi
    done
}

# Función para montar una partición
montar_particion() {
    # Listar los discos y particiones disponibles
    listar_discos_y_particiones

    # Pedir al usuario que ingrese el nombre de la partición que quiere montar
    read -p "Introduce el nombre de la partición (por ejemplo, sda1, sdb1): " PARTICION

    # Verificar que la entrada no esté vacía
    if [ -z "$PARTICION" ]; then
        echo "No has introducido ninguna partición."
        exit 1
    fi

    # Verificar que la partición existe
    if ! lsblk /dev/$PARTICION > /dev/null 2>&1; then
        echo "La partición /dev/$PARTICION no existe."
        exit 1
    fi

    # Crear un directorio temporal para montar la partición
    TEMP_DIR="/tmp/mounted_$PARTICION"
    mkdir -p $TEMP_DIR

    # Montar la partición seleccionada
    sudo mount /dev/$PARTICION $TEMP_DIR

    # Verificar si el montaje fue exitoso
    if mountpoint -q $TEMP_DIR; then
        echo "La partición /dev/$PARTICION ha sido montada en $TEMP_DIR"
    else
        echo "Error al montar la partición /dev/$PARTICION"
    fi
}

# Función para desmontar una partición
desmontar_particion() {
    # Listar los puntos de montaje actuales
    echo "Puntos de montaje actuales:"
    mount | grep "^/dev/"

    # Pedir al usuario que ingrese el nombre de la partición que quiere desmontar
    read -p "Introduce el nombre de la partición que quieres desmontar (por ejemplo, sda1, sdb1): " PARTICION

    # Verificar que la entrada no esté vacía
    if [ -z "$PARTICION" ]; then
        echo "No has introducido ninguna partición."
        exit 1
    fi

    # Desmontar la partición seleccionada
    sudo umount /dev/$PARTICION

    # Verificar si el desmontaje fue exitoso
    if ! mount | grep -q "/dev/$PARTICION"; then
        echo "La partición /dev/$PARTICION ha sido desmontada correctamente"
    else
        echo "Error al desmontar la partición /dev/$PARTICION"
    fi
}

# Preguntar al usuario qué operación desea realizar
echo "¿Qué deseas hacer?"
select opcion in "Montar una partición" "Desmontar una partición" "Salir"; do
    case $opcion in
        "Montar una partición")
            montar_particion
            break
            ;;
        "Desmontar una partición")
            desmontar_particion
            break
            ;;
        "Salir")
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción no válida. Por favor selecciona 1, 2 o 3."
            ;;
    esac
done
