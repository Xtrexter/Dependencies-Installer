#!/bin/bash
# Xtrexter tarafından: Solus GNOME + RX460 + Vulkan optimize betiği
# Gamemode kaldırıldı, sürücüler eklendi.

set -e
echo "🚀 Solus GNOME + RX460 performans optimizasyonuna başlıyoruz!"

# 1) Depo güncellemesi
echo "[1] Depolar güncelleniyor..."
sudo eopkg update-repo
sudo eopkg upgrade -y
echo "→ Sistem güncel."

# 2) Gereksiz servisleri kapatma
echo "[2] Gereksiz sistem servisleri durduruluyor..."
services=(bluetooth cups tracker-miner-fs-3 tracker-store)
for svc in "${services[@]}"; do
  if systemctl list-unit-files | grep -q "${svc}.service"; then
    sudo systemctl disable "${svc}.service" --now || true
    echo "   • ${svc}.service devre dışı."
  fi
done

# 3) RX460 ekran kartı için Mesa + Vulkan
echo "[3] RX460 için Mesa/OpenGL/Vulkan paketleri kuruluyor..."
sudo eopkg install -y mesa mesa-demos vulkan vulkan-32bit || true
echo "   • Mesa, Vulkan & 32-bit destek tamam."

# 4) GNOME Shell animasyonlarını kapatma
echo "[4] GNOME animasyonları kapatılıyor..."
gsettings set org.gnome.desktop.interface enable-animations false

# 5) Swappiness azaltma (RAM önceliği)
echo "[5] vm.swappiness=10 yapılıyor..."
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf
sudo sysctl -p /etc/sysctl.d/99-swappiness.conf >/dev/null

# 6) Flatpak gereksiz paket temizliği
echo "[6] Flatpak temizleniyor..."
flatpak uninstall --unused -y || true

# 7) Hafif tema ve ikonlar
echo "[7] Papirus ikon teması kuruluyor..."
sudo eopkg install -y papirus-icon-theme || echo "   ⚠️ Papirus yüklenemedi."
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'

# 8) Tracker dizinleme kapatma (arama hızlandırma)
echo "[8] Tracker dizinleme devre dışı..."
systemctl --user mask tracker-extract-3.service tracker-miner-fs-3.service \
  tracker-miner-rss-3.service tracker-writeback-3.service tracker-xdg-portal-3.service || true
tracker3 reset -s -r || true

# 9) GRUB bekleme süresi (tek sistem için)
if [ -f /etc/default/grub ]; then
  echo "[9] GRUB_TIMEOUT=0 yapılıyor..."
  sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub || true
  sudo update-grub || true
fi

echo "✅ Tüm optimizasyonlar çalıştırıldı. Lütfen sistemi yeniden başlat."
exit 0
