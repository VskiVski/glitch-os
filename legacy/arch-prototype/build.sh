#!/usr/bin/env bash
# GLITCH OS — build da ISO (requer Arch Linux + root)
# Estratégia: usa o perfil releng oficial do archiso como base e aplica o overlay GLITCH.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="${WORK:-$ROOT/build/work}"
OUT="${OUT:-$ROOT/build/out}"
RELENG="/usr/lib/archiso/configs/releng"

[[ $EUID -eq 0 ]] || { echo "erro: correr como root (sudo ./build.sh)" >&2; exit 1; }
[[ -d "$RELENG" ]] || { echo "erro: archiso não instalado (pacman -S archiso)" >&2; exit 1; }

echo "==> [1/6] Preparar perfil (releng + overlay)"
rm -rf "$WORK"
mkdir -p "$WORK" "$OUT"
cp -a "$RELENG" "$WORK/profile"

echo "==> [2/6] Pacotes GLITCH"
{
    echo ""
    echo "# --- GLITCH OS ---"
    cat "$ROOT"/packages/*.list | grep -vE '^\s*(#|$)'
} >> "$WORK/profile/packages.x86_64"

echo "==> [3/6] Overlay airootfs (configs, units)"
cp -a "$ROOT/archiso/overlay/airootfs/." "$WORK/profile/airootfs/"

echo "==> [4/6] GLITCH Engine"
install -Dm755 "$ROOT"/glitch-engine/glitch-* -t "$WORK/profile/airootfs/usr/bin/"
mkdir -p "$WORK/profile/airootfs/etc/systemd/system/multi-user.target.wants"
ln -sf /usr/lib/systemd/system/glitch-engine.service \
    "$WORK/profile/airootfs/etc/systemd/system/multi-user.target.wants/glitch-engine.service"

echo "==> [5/6] Tema GLITCH DARK"
install -Dm644 "$ROOT/theme/colors/GlitchDark.colors" \
    "$WORK/profile/airootfs/usr/share/color-schemes/GlitchDark.colors"
mkdir -p "$WORK/profile/airootfs/usr/share/sddm/themes"
cp -a "$ROOT/theme/sddm/glitch-os" "$WORK/profile/airootfs/usr/share/sddm/themes/"
install -Dm644 "$ROOT/theme/wallpapers/glitch-dark.png" \
    "$WORK/profile/airootfs/usr/share/backgrounds/glitch-os/glitch-dark.png"

# identidade do profiledef
sed -i \
    -e 's/^iso_name=.*/iso_name="glitchos"/' \
    -e 's/^iso_label=.*/iso_label="GLITCH_OS_$(date +%Y%m)"/' \
    -e 's/^iso_publisher=.*/iso_publisher="GLITCH OS"/' \
    -e 's/^iso_application=.*/iso_application="GLITCH OS - Ultra Performance, Gaming, Terror"/' \
    "$WORK/profile/profiledef.sh"

echo "==> [6/6] mkarchiso (isto demora)"
mkarchiso -v -w "$WORK/chroot" -o "$OUT" "$WORK/profile"

echo ""
echo "████████████████████████████████████"
echo "  ISO pronta: $OUT"
ls -lh "$OUT"/*.iso
