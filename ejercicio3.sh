#!/bin/bash

# Labo 2 - Ejercicio 2 - Scripting y Procesos  - Breyson Barrios 

#-----------------------------------------------------------------------

# Definir el directorio que se va a monitorear

DIRECTORIO="/home/breyson14/Escritorio"
LOGFILE="/home/breyson14/cambios.log"

# Setear el monitoreo y notificaciones según el cambio  que se ejecute

inotifywait -m -r -e create -e modify -e delete --format '%T %w%f %e' --timefmt '%Y-%m-%d %H:%M:%S' "$DIRECTORIO" |
while read timestamp archivo evento
do
    # Registrar los eventos en el archivo .log
    
    echo "$timestamp - $evento en $archivo" >> "$LOGFILE"
done

