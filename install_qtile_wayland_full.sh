#!/bin/bash
set -e

echo "🚀 Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

echo "📦 Instalando dependencias generales y herramientas de compilación..."
sudo apt install -y build-essential git python3 python3-pip python3-setuptools python3-wheel \
libxkbcommon-dev libwayland-dev libcairo2-dev libpango1.0-dev libgdk-pixbuf2.0-dev \
cmake pkg-config python3-dev libegl1-mesa-dev libgbm-dev libinput-dev libx11-dev libxcb1-dev

echo "📥 Instalando libwlroots-dev desde repositorio experimental..."
# Añadir temporalmente repositorio experimental
echo "deb http://deb.debian.org/debian/ experimental main" | sudo tee /etc/apt/sources.list.d/experimental.list
sudo apt update
sudo apt install -t experimental -y libwlroots-dev
# Eliminar repositorio experimental
sudo rm /etc/apt/sources.list.d/experimental.list
sudo apt update

echo "📥 Instalando python3-pywlroots desde pip..."
pip install pywlroots

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
# Lanzador Wayland y X11
sudo apt install -y rofi wofi
# Picom (opcional sobre Xwayland)
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
