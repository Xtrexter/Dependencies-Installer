#!/bin/bash
#Geliştirici Ortam Scripti

echo "🔧 [1/5] Sistem güncelleniyor..."
sudo apt update && sudo apt upgrade -y

echo "📦 [2/5] Geliştirme araçları kuruluyor..."
sudo apt install -y build-essential git cmake gdb valgrind \
    manpages-dev python3 python3-pip clang pkg-config make gcc g++ \
    curl wget htop lsb-release lsof neofetch tree unzip

echo "🧠 [3/5] Liquorix kernel kuruluyor..."
sudo apt install -y gnupg ca-certificates
echo 'deb http://liquorix.net/debian bookworm main' | sudo tee /etc/apt/sources.list.d/liquorix.list
wget -O- https://liquorix.net/liquorix-keyring.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/liquorix-archive-keyring.gpg > /dev/null
echo 'Signed-By: /usr/share/keyrings/liquorix-archive-keyring.gpg' | sudo tee -a /etc/apt/sources.list.d/liquorix.list

sudo apt update
sudo apt install -y linux-image-liquorix-amd64 linux-headers-liquorix-amd64

echo "🛠️ [4/5] Flatpak ve VS Code kuruluyor..."
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.visualstudio.code

echo "🎨 [5/5] XFCE ayarları yapılandırılıyor..."
xfconf-query -c xfwm4 -p /general/theme -s "Greybird"
xfconf-query -c xfce4-panel -p /panels/panel-0/size -s 28
xfconf-query -c xfce4-desktop -p /desktop-icons/style -s 0

echo "✅ Kurulum tamamlandı. Sistemi yeniden başlatıp Liquorix kernel ile açmayı unutma!"
neofetch
