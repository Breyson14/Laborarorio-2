#!/bin/bash

pwd

ls

echo 1. Numero de CPUs:¨

nproc

echo 2. Total de memoria RAM disponible:¨

free -h | awk 'NR==2 {print $2}'

echo 3. Espacio libre en el disco:

df -h / | awk 'NR==2 {print $4}'

echo 4.Version del kernel de linux:

uname -r

echo 5. Tiempo de actividad del sistema:

uptime -p

echo 6. Informacion sobre sistema operativo:

lsb_release -d 

echo 7. Nombre del host del sistema:

hostname

echo 8. Uso de la memoria swap:

cat /proc/meminfo | grep swap
