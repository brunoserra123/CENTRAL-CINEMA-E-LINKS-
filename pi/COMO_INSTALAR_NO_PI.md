# 🍓 Plano Raspberry Pi 3: Monitor 24/7 & Sentinela Vigilante

> **Objetivo:** Transformar seu Raspberry Pi 3 parado em um **Monitor Físico Dedicado de Cinema** (HDMI na TV ou monitor pequeno) e **Sentinela Vigilante de Uptime** (vigia o Mac mini 24/7 e avisa no WhatsApp/Discord se cair).

---

## 📦 O que já deixamos pronto para você:

Na pasta [c:\Users\brunoserra\Documents\Jellyfin\RaspberryPi3](file:///c:/Users/brunoserra/Documents/Jellyfin/RaspberryPi3):
1. **`sentinela_vigilante_pi.py`**: Robô que roda 24/7 no Pi, vigia o Mac mini (`192.168.15.58:8096`), o RV415 e a internet. Se cair, manda mensagem na hora no seu WhatsApp (`556196522309`) e no Discord! Quando volta, avisa que voltou!
2. **`kiosk_cinema.sh`**: Desativa descansos de tela, oculta o mouse e abre a sua **Central de Cinema** em tela cheia na TV/Monitor HDMI.
3. **`sentinela-pi.service`**: Serviço para o sentinela rodar invisível em segundo plano sem travar.
4. **`instalar_tudo_pi.sh`**: Instalador automático que configura tudo em 1 comando!

---

## 🚀 Como Colocar para Rodar (Passo a Passo em 3 Etapas):

### Etapa 1 • Gravar o Sistema no Cartão MicroSD (no PC)
1. Baixe e abra o programa gratuito oficial **[Raspberry Pi Imager](https://www.raspberrypi.com/software/)**.
2. **Dispositivo:** Escolha *Raspberry Pi 3*.
3. **Sistema Operacional:** Escolha *Raspberry Pi OS (32-bit)* com Desktop.
4. Clique na engrenagem ⚙️ (Configurações avançadas) para já deixar pré-configurado:
   - **Nome do Usuário:** `pi` (ou `bruno`) e sua senha.
   - **Wi-Fi:** Coloque o nome e senha da sua rede Wi-Fi de casa.
   - **Habilitar SSH:** Marque para ligar o SSH com autenticação por senha.
5. Clique em **Gravar**.

---

### Etapa 2 • Ligar o Raspberry Pi
1. Coloque o cartão microSD no Raspberry Pi 3.
2. Conecte o cabo HDMI na TV ou monitor pequeno.
3. Conecte a fonte de energia (carregador micro-USB comum de celular).
4. O Raspberry Pi vai ligar, conectar no Wi-Fi e abrir a área de trabalho.

---

### Etapa 3 • Executar o Instalador em 1 Comando!
No terminal do Raspberry Pi (ou via SSH pelo seu PC), basta rodar:

```bash
# Baixa e roda o instalador automático
curl -sSL https://raw.githubusercontent.com/brunoserra123/CENTRAL-CINEMA-E-LINKS-/main/pi/instalar_tudo_pi.sh | bash
```

*(Ou simplesmente copie os arquivos desta pasta `RaspberryPi3` para o Pi via pendrive/WinSCP e execute:)*
```bash
cd RaspberryPi3
bash instalar_tudo_pi.sh
```

---

## 🎉 O que acontece depois disso:
1. **Na TV/Monitor HDMI:** Ao ligar, o Raspberry Pi abre automaticamente a **Central de Cinema** em tela cheia, exibindo os links, os status de downloads e o seu medidor do ChatGPT. A tela nunca desliga nem apaga!
2. **Em Segundo Plano:** O robô fica checando o Mac mini a cada 60 segundos. Se o Mac desligar ou a luz cair, seu celular toca com o alerta do WhatsApp e Discord imediatamente!
