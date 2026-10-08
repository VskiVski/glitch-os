#!/usr/bin/env bash
# GLITCH OS — build da ISO live (Arch)
# Estratégia: perfil releng oficial do archiso + overlay GLITCH.
# Corre como root num Arch Linux (CI: .github/workflows/iso.yml) ou em chroot Arch local.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="${WORK:-/tmp/glitch-iso}"
OUT="${OUT:-$ROOT/iso/out}"

[[ $EUID -eq 0 ]] || { echo "erro: correr como root" >&2; exit 1; }

RELENG=""
for d in /usr/share/archiso/configs/releng /usr/lib/archiso/configs/releng; do
    [[ -d "$d" ]] && RELENG="$d" && break
done
[[ -n "$RELENG" ]] || { echo "erro: archiso nao instalado (pacman -S archiso)" >&2; exit 1; }

echo "==> [1/7] multilib (steam, lib32-*)"
enable_multilib() { # $1 = pacman.conf
    [[ -f "$1" ]] || return 0
    if grep -q '^#\[multilib\]' "$1"; then
        sed -i '/^#\[multilib\]/,+1 s/^#//' "$1"
    fi
}
enable_multilib /etc/pacman.conf
pacman -Syu --noconfirm

echo "==> [2/7] Copiar perfil releng"
rm -rf "$WORK"
mkdir -p "$WORK" "$OUT"
cp -a "$RELENG" "$WORK/profile"
# o pacstrap usa o pacman.conf do perfil, nao o do host
enable_multilib "$WORK/profile/pacman.conf"

echo "==> [3/7] Pacotes GLITCH"
cat "$ROOT/iso/packages.x86_64" >> "$WORK/profile/packages.x86_64"

echo "==> [4/7] GLITCH Engine + tema (fonte unica: config/files)"
cp -a "$ROOT/config/files/." "$WORK/profile/airootfs/"
chmod 755 "$WORK/profile/airootfs/usr/bin/"glitch-*
chmod 755 "$WORK/profile/airootfs/etc/skel/.config/plasma-workspace/env/glitch-env.sh"

echo "==> [5/7] Overlay Arch (live user, autologin, hostname)"
cp -a "$ROOT/iso/overlay/airootfs/." "$WORK/profile/airootfs/"

# symlinks systemd criados aqui (git em Windows nao guarda symlinks de forma fiavel)
cd "$WORK/profile/airootfs/etc/systemd/system"
mkdir -p graphical.target.wants multi-user.target.wants
ln -sf /usr/lib/systemd/system/graphical.target default.target
ln -sf /usr/lib/systemd/system/sddm.service graphical.target.wants/sddm.service
ln -sf /usr/lib/systemd/system/NetworkManager.service multi-user.target.wants/NetworkManager.service
ln -sf /usr/lib/systemd/system/glitch-engine.service multi-user.target.wants/glitch-engine.service
ln -sf /usr/lib/systemd/system/glitch-live-user.service multi-user.target.wants/glitch-live-user.service
ln -sf /usr/lib/systemd/system/systemd-zram-generator@.service \
    "multi-user.target.wants/systemd-zram-generator@zram0.service"
cd "$ROOT"

echo "==> [6/7] Identidade no profiledef"
sed -i \
    -e 's/^iso_name=.*/iso_name="glitch-os"/' \
    -e "s/^iso_label=.*/iso_label=\"GLITCH_OS_$(date +%Y%m)\"/" \
    -e 's/^iso_publisher=.*/iso_publisher="GLITCH OS"/' \
    -e 's/^iso_application=.*/iso_application="GLITCH OS - Ultra Performance, Gaming, Terror"/' \
    "$WORK/profile/profiledef.sh"

echo "==> [7/7] mkarchiso (demora 15-40 min)"
mkarchiso -v -w "$WORK/chroot" -o "$OUT" "$WORK/profile"

echo ""
echo "████████████████████████████████████"
echo "  ISO pronta: $OUT"
ls -lh "$OUT"/*.iso
