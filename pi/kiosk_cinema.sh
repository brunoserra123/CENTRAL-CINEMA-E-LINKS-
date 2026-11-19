#!/bin/bash
# ==============================================================================
# Modo Kiosk 24/7 - Central de Cinema no Raspberry Pi 3
# Abre a Central de Cinema em tela cheia na TV / Monitor HDMI sem protetor de tela
# ==============================================================================

# 1. Desativa descanso de tela e desligamento automático do monitor HDMI
xset s noblank
xset s off
xset -dpms

# 2. Oculta o cursor do mouse após 2 segundos de inatividade
which unclutter >/dev/null 2>&1 && unclutter -idle 2 -root &

# 3. Aguarda 5 segundos para a rede Wi-Fi conectar
sleep 5

# 4. URL da sua Central de Cinema (GitHub Pages oficial com Medidor do ChatGPT)
URL_CINEMA="https://brunoserra123.github.io/CENTRAL-CINEMA-E-LINKS-/"

# 5. Evita mensagem de "O Chromium não fechou corretamente"
if [ -d "$HOME/.config/chromium/Default" ]; then
    sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' "$HOME/.config/chromium/Default/Preferences" 2>/dev/null
    sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' "$HOME/.config/chromium/Default/Preferences" 2>/dev/null
fi

# 6. Dispara o Chromium em tela cheia (Modo Kiosk)
chromium-browser \
    --noerrdialogs \
    --disable-infobars \
    --kiosk \
    --disable-translate \
    --check-for-update-interval=31536000 \
    "$URL_CINEMA"
