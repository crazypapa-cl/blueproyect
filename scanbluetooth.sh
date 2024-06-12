#!/bin/bash

# Nombre del adaptador Bluetooth (alias)
nuevo_nombre="CRAZYLAB"

# Función para manejar señales de terminación
cleanup() {
    echo "Deteniendo el escaneo..."
    bluetoothctl scan off
    exit 0
}

# Atrapar señales de interrupción y terminación
trap cleanup SIGINT SIGTERM

# Obtener información del adaptador Bluetooth
adapter_info=$(bluetoothctl show)

# Mostrar información del adaptador Bluetooth
echo "Información del adaptador Bluetooth:"
echo "$adapter_info"
echo "-------------------------------------"

# Cambiar el nombre del adaptador Bluetooth
echo "Cambiando el nombre del adaptador Bluetooth a: $nuevo_nombre"
bluetoothctl system-alias "$nuevo_nombre"

# Verificar el cambio de nombre
nuevo_adapter_info=$(bluetoothctl show)
echo "Información actualizada del adaptador Bluetooth:"
echo "$nuevo_adapter_info"
echo "-------------------------------------"

# Habilitar el adaptador Bluetooth
bluetoothctl power on

# Iniciar el escaneo
bluetoothctl scan on &

# Esperar 10 segundos para escanear los dispositivos
sleep 10

# Detener el escaneo
bluetoothctl scan off

# Listar los dispositivos encontrados
devices=$(bluetoothctl devices)

# Mostrar los dispositivos encontrados
echo "Dispositivos Bluetooth encontrados:"
echo "$devices"