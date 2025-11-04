#!/usr/bin/env bash
# apply_hardening.sh - Apply example hardening (firewalld + fail2ban) on Rocky/CentOS/RHEL
set -euo pipefail

echo "[*] Creating firewalld zone 'hardening'..."
sudo firewall-cmd --permanent --new-zone=hardening || true
sudo firewall-cmd --permanent --zone=hardening --add-service=ssh
sudo firewall-cmd --permanent --zone=hardening --add-service=http
sudo firewall-cmd --permanent --zone=hardening --add-rich-rule='rule family="ipv4" source address="192.168.0.0/24" accept'
sudo firewall-cmd --permanent --zone=hardening --add-icmp-block=echo-request
# Note: change interface name as needed (e.g. ens3)
sudo firewall-cmd --permanent --zone=hardening --change-interface=eth0 || true
sudo firewall-cmd --reload

echo "[*] Installing and applying fail2ban configuration..."
sudo dnf install -y fail2ban || true
sudo mkdir -p /etc/fail2ban/jail.d
sudo cp configs/jail.local /etc/fail2ban/jail.d/hardening.local
sudo systemctl enable --now fail2ban

echo "[*] Done. Check 'sudo firewall-cmd --list-all --zone=hardening' and 'sudo fail2ban-client status'"
