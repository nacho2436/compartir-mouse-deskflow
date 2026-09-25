#!/bin/bash
# Reinstala el servidor de Deskflow (compartir mouse/teclado) en este equipo
set -e
DIR="$(dirname "$0")"

echo "== Instalando Deskflow =="
sudo apt install -y deskflow

echo "== Restaurando configuración =="
mkdir -p ~/.config/Deskflow ~/.config/systemd/user
cp "$DIR/config/deskflow-server.conf" ~/.config/Deskflow/
cp "$DIR/config/deskflow-server.service" ~/.config/systemd/user/

# Retirar el método antiguo de autostart si existiera (chocaría con el servicio)
rm -f ~/.config/autostart/deskflow-server.desktop

echo "== Activando servicio =="
systemctl --user daemon-reload
systemctl --user enable --now deskflow-server

echo "== Listo =="
echo "En el equipo cliente (mint) ejecuta:  deskflow-core client $(hostname -I | awk '{print $1}')"
