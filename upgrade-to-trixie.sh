#!/bin/bash

set -e  # Hata olursa betiği durdurur
echo "=== LMDE to Debian Trixie Geçiş Başlatılıyor ==="

# 1. root musun kontrol et
if [[ $EUID -ne 0 ]]; then
  echo "Lütfen bu betiği root olarak çalıştır (sudo ile)"
  exit 1
fi

# 2. Güncel sistemle başlayalım
echo "[1/5] Sistem güncelleniyor..."
apt update && apt full-upgrade -y

# 3. Mint kaynaklarını devre dışı bırak
echo "[2/5] Mint kaynakları devre dışı bırakılıyor..."
MINT_REPO="/etc/apt/sources.list.d/official-package-repositories.list"
if [[ -f "$MINT_REPO" ]]; then
  mv "$MINT_REPO" "${MINT_REPO}.bak"
  echo "Mint deposu yedeğe alındı: ${MINT_REPO}.bak"
else
  echo "Mint deposu bulunamadı, atlanıyor."
fi

# 4. Debian kaynaklarını Trixie olarak değiştir
echo "[3/5] sources.list Debian Trixie'ye ayarlanıyor..."
cat > /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb http://security.debian.org/ trixie-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware
EOF

echo "Yeni kaynak listesi yazıldı."

# 5. Paket listesini güncelle
echo "[4/5] Paket listesi yenileniyor..."
apt update

# 6. Trixie'ye geçiş başlasın
echo "[5/5] Trixie’ye yükseltiliyor..."
apt full-upgrade -y

echo "=== Trixie Geçişi Tamamlandı! Sistemi yeniden başlatman önerilir. ==="
