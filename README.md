# 🖱️ Compartir mouse y teclado entre equipos (Deskflow)

Solución para usar un solo mouse y teclado entre **dos equipos**:

| Equipo | Rol | Sistema |
|--------|-----|---------|
| jose-Vostro-3405 | Servidor (mouse/teclado conectados aquí) | Ubuntu (Wayland/GNOME) |
| mint | Cliente (controlado desde el servidor) | Linux Mint |

Un solo mouse: al llegar al borde derecho de la pantalla del Vostro,
el control pasa a la pantalla del equipo Mint (y vuelve por el borde
izquierdo). El portapapeles también se comparte entre ambos.

## Cómo está montado (servidor — este equipo)

El servidor corre como **servicio de systemd de usuario**
(`~/.config/systemd/user/deskflow-server.service`): arranca solo al
iniciar sesión, se reinicia solo si se cae y escribe su log en
`~/.config/Deskflow/deskflow-server.log`.

Comandos útiles:

```bash
systemctl --user status deskflow-server   # ver estado
systemctl --user restart deskflow-server  # reiniciarlo
tail -f ~/.config/Deskflow/deskflow-server.log   # ver log en vivo
```

⚠️ NO usar a la vez el autostart antiguo (`~/.config/autostart/deskflow-server.desktop`)
ni lanzar `deskflow-core server` a mano: daría "an instance of deskflow
core is already running". El servicio systemd es el único mecanismo.

## Reinstalación (servidor — este equipo)

```bash
sudo apt install deskflow
mkdir -p ~/.config/Deskflow
cp config/deskflow-server.conf ~/.config/Deskflow/
cp config/deskflow-server.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now deskflow-server
```

(O simplemente ejecutar `./instalar.sh`.)

## Reinstalación / conexión (cliente — equipo Mint)

```bash
sudo apt install deskflow
deskflow-core client 192.168.1.17   # IP actual del Vostro
```

Nota: la IP la asigna el router (DHCP); si el Mint no conecta,
comprobar la IP vigente del Vostro con `hostname -I`. El cliente
reintenta la conexión solo mientras esté corriendo.

## Si deja de funcionar (runbook)

1. **Estado del servicio**: `systemctl --user status deskflow-server`.
2. **Síntoma conocido (falla del 2026-09-25)**: en el log aparece en
   bucle `ei: Disconnected by EIS` / `disconnected from eis` y el
   control deja de pasar al Mint, aunque el proceso siga corriendo.
   Es el portal de captura de input de Wayland que queda en mal
   estado. Arreglo:

   ```bash
   systemctl --user restart xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-desktop-portal
   systemctl --user restart deskflow-server
   ```

3. La advertencia `failed to apply barrier` del log es **benigna**:
   también aparece cuando todo funciona. No es indicio de falla.
4. **Verificar que el servidor escucha**: `ss -tln | grep 24800`.
5. Si el servidor está bien pero el Mint no entra: revisar en el
   Mint que el cliente siga corriendo y que apunte a la IP correcta
   del Vostro.

## Notas

- Las llaves TLS (`~/.config/Deskflow/tls/`) NO se respaldan: se
  regeneran solas en cada equipo al primer arranque.
- Si cambias el nombre de un equipo, edítalo en
  `config/deskflow-server.conf` (secciones `screens` y `links`).
- `config/deskflow-server.desktop` (autostart) es el método antiguo,
  reemplazado por el servicio systemd. Ya no se usa.
- Sesión de origen: "Compartir mouse entre Ubuntu y Linux Mint".
  Respaldo verificado: 2026-09-15 11:05. Documentado servicio systemd
  y runbook tras la falla del 2026-09-25.

## ☕ Donaciones

Si este proyecto te sirve, apóyame en Ko-fi:

[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/F1F81BZQDW)
