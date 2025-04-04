[Unit]
Description=Servicio de Monitoreo de Cambios en Directorios
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash /home/breyson14/ejercicio3.sh
WorkingDirectory=/home/breyson14
Restart=always

[Install]
WantedBy=multi-user.target

