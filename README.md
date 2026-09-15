# Compartir mouse y teclado entre equipos (Deskflow)

Solución para usar un solo mouse y teclado entre **dos equipos**:

| Equipo | Rol | Sistema |
|--------|-----|---------|
| jose-Vostro-3405 | Servidor (mouse/teclado conectados aquí) | Ubuntu |
| mint | Cliente (controlado desde el servidor) | Linux Mint |

Un solo mouse: al llegar al borde derecho de la pantalla del Vostro,
el control pasa a la pantalla del equipo Mint (y vuelve por el borde
izquierdo). El portapapeles también se comparte entre ambos.

## Reinstalación (servidor — este equipo)

```bash
sudo apt install deskflow
mkdir -p ~/.config/Deskflow ~/.config/autostart
cp config/deskflow-server.conf ~/.config/Deskflow/
cp config/deskflow-server.desktop ~/.config/autostart/
deskflow-core server &   # o reiniciar sesión para el autostart
```

## Reinstalación (cliente — equipo Mint)

```bash
sudo apt install deskflow
deskflow-core client <IP-del-servidor>   # ejecutar en el Mint
```

## Notas

- Las llaves TLS (`~/.config/Deskflow/tls/`) NO se respaldan: se
  regeneran solas en cada equipo al primer arranque.
- Si cambias el nombre de un equipo, edítalo en
  `config/deskflow-server.conf` (secciones `screens` y `links`).
- Sesión de origen: "Compartir mouse entre Ubuntu y Linux Mint".
Respaldo verificado: 2026-09-15 11:05
