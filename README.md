# Hardening Defensivo — Rocky Linux (sanitizado)

Repositorio con la documentación y archivos de ejemplo del laboratorio **Hardening Defensivo**.
El objetivo es mostrar configuración de firewall (firewalld), reglas por zona, rich rules, bloqueo de ICMP,
limitación de servicios (SSH/FTP/MySQL), y protección dinámica con **Fail2Ban** para mitigar fuerza bruta.

> ⚠️ Este material es educativo y debe aplicarse solo en entornos de prueba o con autorización. No subir claves privadas ni datos sensibles.

## Contenido
- `README.md` (este archivo)
- `NOTES.md` — notas detalladas y pasos ejecutados.
- `configs/jail.local` — ejemplo de configuración para Fail2Ban.
- `scripts/apply_hardening.sh` — script ejemplo para aplicar configuraciones.
- `docs/` — PDF del laboratorio (opcional).
- `.gitignore` — evita subir evidencias sensibles.

## Resumen rápido
1. Revisar servicios activos y determinar zona del firewall.
2. Crear zonas y aplicar rich-rules o services permitidos.
3. Limitar ICMP y bloquear ping cuando se requiera.
4. Configurar Fail2Ban con jails para SSH, FTP y web login.
5. Probar bloqueo (intento de fuerza bruta simulado) y verificar logs.
6. Documentar y revertir cambios en caso necesario.

## Cómo usar
1. Clona o descarga este repo.
2. Revisa `NOTES.md` y `configs/jail.local` antes de aplicar en producción.
3. Para aplicar configuraciones de ejemplo (en Rocky/CentOS/RHEL):
```bash
# Aplicar reglas firewalld (ejemplo)
sudo firewall-cmd --permanent --new-zone=hardening
sudo firewall-cmd --permanent --zone=hardening --add-service=ssh
sudo firewall-cmd --permanent --zone=hardening --add-service=http
sudo firewall-cmd --permanent --zone=hardening --add-rich-rule='rule family="ipv4" source address="192.168.0.0/24" accept'
sudo firewall-cmd --permanent --zone=hardening --add-icmp-block=echo-request
sudo firewall-cmd --reload

# Instalar fail2ban (si no está)
sudo dnf install -y fail2ban

# Copiar configuración de ejemplo
sudo cp configs/jail.local /etc/fail2ban/jail.d/hardening.local
sudo systemctl enable --now fail2ban
sudo journalctl -u fail2ban -f
