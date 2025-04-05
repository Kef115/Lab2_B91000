#!/bin/bash

#Otorgar permisos al script parta poder ejecutarse con ./
Usuario=$(whoami)
chmod +x /home/$Usuario/L2_2_B91000.sh



if [ $# -eq 0 ]; then
    echo "No se obtuvo ningun proceso a ejecutar"
    exit 1
fi

# Ejecutar el comando en segundo plano
"$@" &
PID=$!
Archivo_Log="monitoreo.txt"
Archivo_Datos="datos_grafico.txt"

# Mostrar que el proceso se ejecutó correctamente
if kill -0 $PID 2>/dev/null; then
    echo "El proceso con PID $PID se está ejecutando en segundo plano."
else
    echo "Error: No se pudo iniciar el proceso."
    exit 1
fi

# Inicializar los archivos de log y datos
echo "Monitoreo del proceso cuyo PID es $PID - ejecutado con el comando: $*" > "$Archivo_Log"
echo "timestamp cpu mem" > "$Archivo_Datos"

# Monitorear el proceso periódicamente
while kill -0 $PID 2>/dev/null; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    TIMESTAMP_UNIX=$(date '+%s') # Timestamp en formato UNIX para graficar
    # Obtener el consumo de CPU y memoria usando ps
    INFO=$(ps -p $PID -o %cpu,%mem --no-headers)
    CPU=$(echo $INFO | awk '{print $1}')
    MEM=$(echo $INFO | awk '{print $2}')
    # Registrar la información en los archivos
    echo "$TIMESTAMP, $CPU, $MEM" >> "$Archivo_Log"
    echo "$TIMESTAMP_UNIX $CPU $MEM" >> "$Archivo_Datos"
    sleep 5  # Esperar 5 segundos antes de la siguiente lectura
done

echo "El proceso con PID $PID ha terminado."
