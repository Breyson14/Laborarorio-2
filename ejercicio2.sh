#!/bin/bash

# Labo 2 - Ejercicio 2 - Scripting y Procesos  - Breyson Barrios 

#-----------------------------------------------------------------------
# Verificar que el argumento que ingresa el usuario sea correcto
if [ $# -eq 0 ]; then
    echo "Error: Es necesario especificar un programa para monitorear."
    echo "Ejemplo: ./ejercicio.sh nombre_programa"
    exit 1
fi

# Archivo para ir guardando los datos
ARCHIVO_LOG="Registro_de_Monitoreo.log"  
#Definir cada cuantos segundos se hará una lectura
TIEMPO_INTERVALO=2          

# Asegurar que el archivo de registro este limpio
> "$ARCHIVO_LOG"

# Finalizacion del monitoreo
terminar_monitoreo() {
    echo "Monitoreo Finalizado - Gráfico Generado "
    crear_grafico
    exit 0
}

# Graficacion de los datos recolectados
crear_grafico() {
    gnuplot <<- EOF
    set terminal png
    set output 'grafico.png'
    set title "Uso de Recursos de $PROGRAMA"
    set xlabel "Tiempo (segundos)"
    set ylabel "Porcentaje"
    set grid
    set style data lines
    plot "$ARCHIVO_LOG" using 1:2 title "Uso de CPU (%)", \
         "$ARCHIVO_LOG" using 1:3 title "Uso de Memoria (%)"
EOF
}

# Interrupcion y ejecutar la limpieza
trap terminar_monitoreo SIGINT

# Leer el programa que se monitoreara en segundo plano
PROGRAMA="$1"
echo "Monitoreando el programa: $PROGRAMA"

"$@" &
PID=$!


sleep 2

# validación de que efectivamente el programa esta corriendo
if ! ps -p $PID > /dev/null; then
    echo "Error: No se pudo iniciar el programa correctamente."
    exit 1
fi

# Empezar el monitoreo
echo "Iniciando monitoreo de recursos..."

# Dar formato al archivo .log donde se lleva el registro
echo "Tiempo(segundos) Uso_CPU(%) Uso_Memoria(%)" > "$ARCHIVO_LOG"

# setear el monitoreo
TIEMPO=0
while ps -p $PID > /dev/null; do
    # Obtener el uso de CPU y memoria del proceso
    RECURSOS=$(ps -p $PID -o %cpu,%mem --no-headers)
    USO_CPU=$(echo $RECURSOS | awk '{print $1}')
    USO_MEMORIA=$(echo $RECURSOS | awk '{print $2}')

    # Guardar los datos en el archivo .log
    echo "$TIEMPO $USO_CPU $USO_MEMORIA" >> "$ARCHIVO_LOG"

    # setear los intervalos
    sleep $TIEMPO_INTERVALO
    TIEMPO=$((TIEMPO + TIEMPO_INTERVALO))
done

# Terminar monitoreo y generar gráfico cuando el proceso termine
terminar_monitoreo

