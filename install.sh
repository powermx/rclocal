#!/bin/bash
#Instalador de rc.local
#Telegram: https://t.me/powermx
#Grupo: https://t.me/vpnmx
echo -e "Instalando rc.local"
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script debe ejecutarse como root"
  exit 1
fi
if [ ! -f /etc/rc.local ]; then
  cat << 'EOF' > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# Este script se ejecuta al final del arranque multiusuario.
# Asegúrese de que el script devuelva "0" en caso de éxito o cualquier otro valor en caso de error.
#
# En caso de error, puede agregar comandos aquí.

exit 0
EOF
fi
chmod +x /etc/rc.local
if [ ! -f /etc/systemd/system/rc-local.service ]; then
  cat << 'EOF' > /etc/systemd/system/rc-local.service
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF
fi

systemctl daemon-reload
systemctl enable rc-local
systemctl start rc-local
echo "La instalación de rc.local ha sido completada."
