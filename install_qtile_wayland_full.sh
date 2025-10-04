#!/bin/bash
set -e

echo "🚀 Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

echo "📦 Instalando dependencias de Qtile Wayland..."
sudo apt install -y git build-essential python3 python3-pip python3-setuptools python3-wheel \
python3-cffi python3-xcffib libwlroots-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev \
pkg-config python3-pywlroots libegl1-mesa-dev libgbm-dev libinput-dev libxkbcommon-dev \
libx11-dev libxcb1-dev libxcb-composite0-dev

echo "📥 Clonando repositorio de Qtile..."
cd ~
if [ ! -d "qtile" ]; then
    git clone https://github.com/qtile/qtile.git
else
    echo "📂 Qtile ya existe, actualizando..."
    cd qtile
    git pull
fi
cd qtile

echo "⚙️ Instalando Qtile en modo editable..."
pip install -e .

echo "🖥 Instalando programas adicionales..."
# Rofi y su versión Wayland (uofi)
sudo apt install -y wofi
# Picom (para transparencias sobre Xwayland, opcional en Wayland)
sudo apt install -y picom
# Terminal Kitty
sudo apt install -y kitty
# Gestor de notificaciones Dunst
sudo apt install -y dunst
# Gestor de login LightDM
sudo apt install -y lightdm lightdm-gtk-greeter

echo "📝 Creando archivo de sesión Wayland para LightDM..."
SESSION_FILE="/usr/share/wayland-sessions/qtile-wayland.desktop"
sudo tee $SESSION_FILE > /dev/null <<EOL
[Desktop Entry]
Name=Qtile (Wayland)
Comment=Qtile session running on Wayland
Exec=qtile start -b wayland
Type=Application
DesktopNames=qtile
EOL

echo "✅ Instalación completada."
echo "Para iniciar Qtile Wayland, selecciona 'Qtile (Wayland)' en LightDM."
echo "Si arrancas desde terminal X11, puedes usar: qtile start -b wayland"
