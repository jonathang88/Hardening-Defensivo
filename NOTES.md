
---

## 3) Archivo `NOTES.md` (detallado — copia y pega)

```markdown
# Notas detalladas — Hardening Defensivo (sanitizado)

## 1) Inventario y descubrimiento
- Comprobar servicios: `ss -tulpn` / `ss -tuln`
- Identificar subredes y direcciones de administración (VPN)

## 2) Firewalld — zonas y reglas
- Crear zona personalizada `hardening`:
  - `sudo firewall-cmd --permanent --new-zone=hardening`
  - Añadir servicios permitidos:
    - `sudo firewall-cmd --permanent --zone=hardening --add-service=ssh`
    - `sudo firewall-cmd --permanent --zone=hardening --add-service=http`
  - Añadir rich-rule para permitir subred de administración:
    - `sudo firewall-cmd --permanent --zone=hardening --add-rich-rule='rule family="ipv4" source address="192.168.0.0/24" accept'`
  - Bloquear ICMP echo-request (ping):
    - `sudo firewall-cmd --permanent --zone=hardening --add-icmp-block=echo-request`
  - Recargar:
    - `sudo firewall-cmd --reload`
  - Asociar interfaz a la zona (ajusta `eth0` si tu interfaz tiene otro nombre):
    - `sudo firewall-cmd --permanent --zone=hardening --change-interface=eth0`

## 3) Fail2Ban — configuración básica
- Archivo de ejemplo: `configs/jail.local` (incluido).
- Jails sugeridos: `sshd`, `sshd-ddos`, `http-auth`, `vsftpd`.
- Ajustes recomendados:
  - `bantime` según política (ej. 3600 = 1 hora)
  - `findtime` (ej. 600 = 10 minutos)
  - `maxretry` (ej. 3–5)
- Pasos:
  - Copiar `configs/jail.local` a `/etc/fail2ban/jail.d/hardening.local`
  - `sudo systemctl restart fail2ban`
  - Verificar estado: `sudo fail2ban-client status sshd`

## 4) Pruebas y verificación
- Simular intentos fallidos (solo en laboratorio).
- Ver logs: `/var/log/fail2ban.log` y `journalctl -u fail2ban`.
- Ver reglas activas: `sudo firewall-cmd --list-all --zone=hardening`
- Ver IPs baneadas: `sudo fail2ban-client status sshd` y `sudo ipset list`

## 5) Reversión y automatización
- Mantener copias de seguridad de `/etc/firewalld` y `/etc/fail2ban`.
- Crear script de rollback si es necesario.
- Recomiendo usar Ansible para despliegues reproducibles.
