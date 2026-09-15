#!/bin/bash
# Reinstala el servidor de Deskflow (compartir mouse/teclado) en este equipo
set -e
echo "== Instalando Deskflow =="
sudo apt install -y deskflow

echo "== Restaurando configuración =="
mkdir -p ~/.config/Deskflow ~/.config/autostart
cp "$(dirname "$0")/config/deskflow-server.conf" ~/.config/Deskflow/
cp "$(dirname "$0")/config/deskflow-server.desktop" ~/.config/autostart/

echo "== Listo =="
echo "En el equipo cliente (mint) ejecuta:  deskflow-core client <IP-de-este-equipo>"
