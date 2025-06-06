#!/bin/bash

# Labo 2 - Ejercicio 1 - Scripting usuarios y permisos - Breyson Barrios 

#-----------------------------------------------------------------------

# Verificar que el usuario que ejecuta el script es root

if [ "$(id -u)" -ne 0 ]; then
    echo "- Error: Para ejecutar este script hay que ser usuario root" >&2
    exit 1
fi

# Verificar que los parámetros que se ingresan para ejecutar el script sean correctos

if [ $# -ne 3 ]; then
    echo "- Error: No se indicaron los parámetros correctamente, debe seguir este ejemplo
    ./ejercicio1.sh <usuario> <grupo> <ruta_archivo>" >&2
    exit 1
fi

# Definir las variables importantes

Usuario="$1"
Grupo="$2"
Archivo="$3"

# Verificar que la ruta al archivo indicada exista

if [ ! -e "$Archivo" ]; then
    echo "- Error: La ruta al archivo '$Archivo' no existe" >&2
    exit 1
fi

# Analizar el grupo, si existe se indica, si no se crea como uno nuevo.

if grep -q "^$Grupo:" /etc/group; then
    echo "- El grupo '$Grupo' ya existe"
else
    groupadd "$Grupo"
    echo "- El grupo '$Grupo' ha sido creado exitosamente"
fi

# Analizar el usuario, si existe se indica, si no se crea y se agrega al grupo

if id "$Usuario" &>/dev/null; then
    echo "- El usuario '$Usuario' ya existe"

    if ! groups "$Usuario" | grep -q "\b$Grupo\b"; then
        usermod -aG "$Grupo" "$Usuario"
        echo "- El Usuario '$Usuario' ha sido agregado al grupo '$Grupo'"
    fi
else
    useradd -m -G "$Grupo" "$Usuario"
    echo "- El usuario '$Usuario' ha sido creado y agregado al grupo '$Grupo'"
fi

# Modificar la pertenencia del archivo, para que pertenezca al usuario nuevo y al grupo nuevo.

chown "$Usuario:$Grupo" "$Archivo"
echo "- La pertenencia de '$Archivo' ha sido modificada, ahora pertenece a '$Usuario:$Grupo'"

# Modificar los permisos del archivo

chmod 740 "$Archivo"
echo "- Los permisos de '$Archivo' han sido modificados.Actualmente, el usuario tiene permisos de lectura, escritura y ejecución, el grupo solo tiene permiso de lectura, y el resto de usuarios del sistema no tienen ningún permiso sobre el archivo."

#Salir

exit 0
