#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Sentinela Vigilante do Raspberry Pi 3 - Bruno Serra
Fica rodando 24/7 no Raspberry Pi vigiando o ecossistema.
Se o Mac mini (Servidor Jellyfin), o RV415 ou a Internet caírem,
ele avisa você no WhatsApp e no Discord imediatamente!
Quando o servidor voltar, ele envia a confirmação de retorno!
"""

import time
import socket
import urllib.request
import urllib.parse
import json
import subprocess
from datetime import datetime

# --- CONFIGURAÇÕES ---
MAC_MINI_IP = "192.168.15.58"
MAC_MINI_PORT = 8096  # Porta do Jellyfin
RV415_IP = "192.168.15.10"
CHECK_INTERVAL = 60   # Segundos entre checagens

# WhatsApp (CallMeBot)
WHATSAPP_PHONE = "556196522309"
WHATSAPP_KEY = "3319171"

# Discord Webhook
DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1571861086108393592/1rQqJ86rzTlus50eNPPDxKl2DCef8p-i4s8sLu-_YtLcPISvsgFUbCvO7syGrsZN_C_0"

# Estados prévios para evitar spam de alertas
mac_online = True
internet_online = True

def send_whatsapp(msg):
    try:
        url = f"https://api.callmebot.com/whatsapp.php?phone={WHATSAPP_PHONE}&text={urllib.parse.quote(msg)}&apikey={WHATSAPP_KEY}"
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        urllib.request.urlopen(req, timeout=10)
        print(f"[WHATSAPP] Enviado: {msg[:40]}...")
    except Exception as e:
        print(f"[WHATSAPP] Erro ao enviar: {e}")

def send_discord(title, desc, color=0xE74C3C):
    try:
        payload = {
            "embeds": [{
                "title": title,
                "description": desc,
                "color": color,
                "footer": {"text": "Raspberry Pi 3 • Sentinela Vigilante de Uptime"},
                "timestamp": datetime.utcnow().isoformat()
            }]
        }
        data = json.dumps(payload).encode("utf-8")
        req = urllib.request.Request(DISCORD_WEBHOOK, data=data, headers={"Content-Type": "application/json", "User-Agent": "Mozilla/5.0"})
        urllib.request.urlopen(req, timeout=10)
        print(f"[DISCORD] Enviado: {title}")
    except Exception as e:
        print(f"[DISCORD] Erro ao enviar: {e}")

def check_tcp_port(host, port, timeout=3.0):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(timeout)
            return s.connect_ex((host, port)) == 0
    except Exception:
        return False

def check_internet():
    try:
        # Testa DNS Cloudflare (1.1.1.1) ou Google (8.8.8.8)
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(3.0)
            return s.connect_ex(("1.1.1.1", 53)) == 0
    except Exception:
        return False

def main():
    global mac_online, internet_online
    print("=" * 60)
    print("🍓 INICIANDO SENTINELA VIGILANTE NO RASPBERRY PI 3")
    print(f"📡 Monitorando Mac mini ({MAC_MINI_IP}:{MAC_MINI_PORT}) a cada {CHECK_INTERVAL}s")
    print("=" * 60)
    
    # Mensagem de Inicialização
    send_discord("🍓 Sentinela do Raspberry Pi Ativado!", "O Raspberry Pi 3 está conectado e vigiando o Mac mini e o ecossistema 24 horas por dia.", color=0x2ECC71)

    while True:
        try:
            has_net = check_internet()
            is_mac_up = check_tcp_port(MAC_MINI_IP, MAC_MINI_PORT)

            # 1. Alerta de Internet
            if not has_net and internet_online:
                internet_online = False
                print("⚠️ [ALERTA] A conexão com a Internet caiu!")
            elif has_net and not internet_online:
                internet_online = True
                print("🟢 [RESTABELECIDO] Conexão com a Internet normalizada!")
                send_discord("🌐 Internet Restabelecida!", "A rede Wi-Fi/Internet voltou a funcionar normalmente no Raspberry Pi.", color=0x2ECC71)

            # 2. Alerta do Mac mini (Jellyfin Server)
            if not is_mac_up and mac_online:
                # Faz um segundo teste rápido para evitar falso-positivo
                time.sleep(4)
                if not check_tcp_port(MAC_MINI_IP, MAC_MINI_PORT):
                    mac_online = False
                    agora = datetime.now().strftime("%H:%M de %d/%m")
                    msg_wa = f"🚨 *[ALERTA SERVIDOR JELLYFIN]*\nO seu Mac mini parou de responder às {agora}!\nPode ter faltado luz, travado ou o cabo desconectou."
                    print(f"❌ {msg_wa}")
                    if internet_online:
                        send_whatsapp(msg_wa)
                        send_discord("🚨 ALERTA: Mac mini Parou de Responder!", f"O servidor Jellyfin ({MAC_MINI_IP}:{MAC_MINI_PORT}) não está respondendo às conexões.\nHorário: {agora}.", color=0xE74C3C)

            elif is_mac_up and not mac_online:
                mac_online = True
                agora = datetime.now().strftime("%H:%M de %d/%m")
                msg_wa = f"🟢 *[SERVIDOR RECUPERADO]*\nO Mac mini voltou a funcionar perfeitamente às {agora}! O Jellyfin já está online."
                print(f"✅ {msg_wa}")
                if internet_online:
                    send_whatsapp(msg_wa)
                    send_discord("🟢 Mac mini Voltou a Ficar Online!", f"O servidor Jellyfin restabeleceu a conexão com sucesso às {agora}.\nPronto para assistir!", color=0x2ECC71)

        except Exception as e:
            print("Erro no loop sentinela:", e)

        time.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    main()
