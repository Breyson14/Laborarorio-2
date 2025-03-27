#!/bin/bash

# Ejercicio 2
#-------------------------------------------------------------------

# Descomprimir el archivo comprimido
if [ ! -d "logs" ]; then
    echo "Archivo logs.zip Descomprimido Correctamente"
    unzip -q logs.zip || { echo "Error al descomprimir Archivo logs.zip"; exit 1; }
fi
# Cambios listos
# Probado - funciona bien - si esta descomprimiendo el archivo comprimido

#-------------------------------------------------------------------

# Buscar los archivos en la carpeta nueva que se genero al descomprimir el archivo comprimido
archivos_log=$(find logs -name "*.log" 2>/dev/null)
[ -z "$archivos_log" ] && archivos_log=$(ls logs/*.log 2>/dev/null)

if [ -z "$archivos_log" ]; then
    echo "Error: No se encontraron archivos .log"
    exit 1
fi
# Cambios listos
# Probado - funciona bien - no me tira error a la hora de buscar los archivos

#------------------------------------------------------------------

# Analizar los archivos, filtrar las fechas, buscar la cantidad de "error" y "warning", guardar los resultados en un archivo temporal para que luego se puedan imprimir todas las fechas con su respectiva cantidad de "error" y "warning" extraídas de la información de los archivos.

> conteo.txt  

for archivo in $archivos_log; do
    fecha=$(basename "$archivo" .log | sed 's/.*_//')  
    
    errores=$(grep -c "ERROR" "$archivo")
    warnings=$(grep -c "WARNING" "$archivo")
    
  # Cambios listos
  # Probado - funciona bien 
    
 #-------------------------------------------------------------------
 
 # Imprimir la información del que se recogió de los archivos analizados y se fue almacenando en el archivo temporal
 # Dar el formato de como vamos a ver la información
 # Incluir en cada apartado la información relevante según el ejemplo del profe Fecha-# de Errores-# de Warnings 
 
    echo "$fecha $errores $warnings" >> conteo.txt
    
    echo "Fecha: $fecha"
    echo "Errores: $errores"
    echo "Warnings: $warnings"
    echo "-------------------------"
done

# Encontrar el día con mas errores

dia_con_mas_errores=$(sort -k2 -nr conteo.txt | head -n1 | awk '{print $1}')
echo "Día con mas errores: $dia_con_mas_errores"

# Cambios listos (Formato)
# Funciona bien

#------------------------------------------------------------------------------

# Finalmente, eliminar el archivo temporal que había creado

rm conteo.txt
