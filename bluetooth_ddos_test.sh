#!/bin/bash

# Verifica si el usuario proporcionó una dirección MAC
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 [DIRECCIÓN_MAC]"
    exit 1
fi

MAC_ADDRESS=$1

# Verifica si los comandos necesarios están instalados
echo "Verificando herramientas requeridas..."
for cmd in l2ping rfcomm; do
    if ! command -v $cmd &>/dev/null; then
        echo "El comando $cmd no está instalado. Instalándolo..."
        sudo apt-get update && sudo apt-get install -y bluez
        break
    fi
done

# Opciones de prueba
PING_COUNT=10        # Número de paquetes de ping
RFCOMM_CHANNEL=1     # Canal RFCOMM a probar

echo "Iniciando pruebas con el dispositivo Bluetooth: $MAC_ADDRESS"

# 1. Enviar ráfagas de l2ping
echo "Realizando prueba de latencia con l2ping..."
l2ping -c $PING_COUNT $MAC_ADDRESS
if [ $? -eq 0 ]; then
    echo "Prueba l2ping completada con éxito."
else
    echo "Error durante la prueba l2ping."
fi

# 2. Intentar conexión RFCOMM
echo "Intentando establecer conexión RFCOMM..."
rfcomm connect hci0 $MAC_ADDRESS $RFCOMM_CHANNEL &
RFCOMM_PID=$!

# Espera unos segundos para probar la conexión
sleep 5

# Detener la conexión RFCOMM
echo "Deteniendo conexión RFCOMM..."
kill $RFCOMM_PID
wait $RFCOMM_PID 2>/dev/null

# Finalización del script
echo "Pruebas completadas con el dispositivo $MAC_ADDRESS."