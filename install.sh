#!/bin/bash
set -e

echo "🚀 Sistem güncelleniyor..."
sudo apt update && sudo apt upgrade -y

echo "🛠️ Geliştirici araçları kuruluyor..."
sudo apt install -y build-essential gcc g++ make gdb cmake git tig meld curl wget htop neofetch ufw gnome-disk-utility synaptic

echo "🐍 Python, pip ve venv kuruluyor..."
sudo apt install -y python3 python3-pip python3-venv

echo "🐘 PHP ve Composer kuruluyor..."
sudo apt install -y php php-cli php-mbstring unzip curl
EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('sha384', 'composer-setup.php');")
if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]; then
    php composer-setup.php --quiet
    sudo mv composer.phar /usr/local/bin/composer
    echo "Composer başarıyla kuruldu."
else
    echo "Composer imza doğrulaması başarısız oldu."
fi
php -r "unlink('composer-setup.php');"

echo "🌐 Node.js ve npm kuruluyor (LTS sürüm)..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

echo "📝 Editörler kuruluyor (VS Code, Geany, Neovim)..."
# Microsoft VS Code resmi repo ekleniyor
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm microsoft.gpg

sudo apt update
sudo apt install -y code geany neovim mousepad

echo "💾 Veritabanı araçları kuruluyor (sqlite3, mysql-client)..."
sudo apt install -y sqlite3 mysql-client sqlitebrowser

echo "🛡️ Firewall ufw etkinleştiriliyor..."
sudo ufw enable || echo "ufw etkinleştirilemedi, zaten etkin olabilir."

echo "🔧 Sistem temizliği yapılıyor..."
sudo apt autoremove -y
sudo apt autoclean -y

echo "🎉 Kurulum tamamlandı! Sistem bilgisi gösteriliyor:"
neofetch

echo ""
echo "📢 Windows boot menüsüne eklemek için şu komutları çalıştır:"
echo "sudo os-prober"
echo "sudo update-grub"
echo ""
echo "Artık kodlamaya başlayabilirsin! İyi çalışmalar! 👨‍💻🔥"
