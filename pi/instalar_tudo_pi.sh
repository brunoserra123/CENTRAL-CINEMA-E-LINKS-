#!/bin/bash
# ==============================================================================
# Instalador 1-Clique: Central de Cinema & Sentinela Vigilante no Raspberry Pi 3
# Autor: Bruno Serra & Antigravity
# ==============================================================================

set -e

echo "=========================================================="
echo "🍓 CONFIGURANDO RASPBERRY PI 3: KIOSK CINEMA + SENTINELA"
echo "=========================================================="

# 1. Atualizar pacotes essenciais
echo "📦 1/5 Instalando ferramentas necessárias (unclutter, python3, curl)..."
sudo apt-get update -y
sudo apt-get install -y unclutter python3 python3-pip curl

# 2. Criar diretório de scripts
echo "📁 2/5 Configurando pasta de scripts em /home/$USER/scripts..."
mkdir -p "$HOME/scripts"
cp sentinela_vigilante_pi.py "$HOME/scripts/"
cp kiosk_cinema.sh "$HOME/scripts/"
chmod +x "$HOME/scripts/kiosk_cinema.sh"
chmod +x "$HOME/scripts/sentinela_vigilante_pi.py"

# 3. Configurar o Serviço do Sentinela Vigilante (systemd)
echo "🤖 3/5 Instalando serviço do Sentinela Vigilante 24/7..."
sudo sed -i "s/User=pi/User=$USER/g" sentinela-pi.service
sudo sed -i "s#/home/pi/scripts#/home/$USER/scripts#g" sentinela-pi.service
sudo cp sentinela-pi.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable sentinela-pi.service
sudo systemctl restart sentinela-pi.service

# 4. Configurar Inicialização Automática no Modo Kiosk (Tela Cheia)
echo "📺 4/5 Configurando autostart da Central de Cinema na inicialização..."
AUTOSTART_DIR="$HOME/.config/lxsession/LXDE-pi"
mkdir -p "$AUTOSTART_DIR"

# Adiciona ao autostart se ainda não estiver configurado
if [ -f "$AUTOSTART_DIR/autostart" ]; then
    if ! grep -q "kiosk_cinema.sh" "$AUTOSTART_DIR/autostart"; then
        echo "@bash $HOME/scripts/kiosk_cinema.sh" >> "$AUTOSTART_DIR/autostart"
    fi
else
    cat << EOF > "$AUTOSTART_DIR/autostart"
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xscreensaver -no-splash
@bash $HOME/scripts/kiosk_cinema.sh
EOF
fi

# Suporte adicional para versões mais recentes do Raspberry Pi OS (wayland/labwc/wayfire)
WAYFIRE_CONFIG="$HOME/.config/wayfire.ini"
if [ -f "$WAYFIRE_CONFIG" ]; then
    if ! grep -q "kiosk_cinema" "$WAYFIRE_CONFIG"; then
        echo -e "\n[autostart]\nkiosk = bash $HOME/scripts/kiosk_cinema.sh" >> "$WAYFIRE_CONFIG"
    fi
fi

echo "=========================================================="
echo "✅ TUDO PRONTO COM SUCESSO! 🍿🎉"
echo "=========================================================="
echo "1. O Sentinela Vigilante já está ativo e rodando em segundo plano!"
echo "   (Ele testou sua internet e já enviou o alerta de boas-vindas no Discord!)"
echo "2. Ao reiniciar o Raspberry Pi, ele abrirá direto na sua Central de Cinema em tela cheia!"
echo ""
echo "Deseja reiniciar o Raspberry Pi agora para ver a mágica na TV? (s/n)"
read -r resp
if [[ "$resp" =~ ^([sS]|[yY])$ ]]; then
    sudo reboot
fi
