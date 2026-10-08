# BUILD — GLITCH OS (Fedora Atomic / OCI)

O GLITCH OS é uma **imagem OCI atomic** construída sobre
[universal-blue](https://universal-blue.org) (base `ublue-os/kinoite`,
KDE Plasma + Wayland), no modelo do Bazzite. O `Containerfile` adiciona:
RPM Fusion, pacotes gaming, o **GLITCH Engine** (`/usr/bin/glitch-*`) e o tema
**GLITCH DARK**.

## Build local

Funciona em qualquer máquina com podman ou docker (Linux, Windows, macOS):

```bash
./build.sh            # variante main (GPU AMD/Intel)
./build.sh nvidia     # variante com drivers NVIDIA (base kinoite-nvidia)
```

Ou diretamente:

```bash
podman build --build-arg BASE_IMAGE=ghcr.io/ublue-os/kinoite-main:stable -t glitch-os:latest .
```

## CI

`.github/workflows/image.yml` compila as duas variantes e publica em
`ghcr.io/<owner>/glitch-os{,-nvidia}` (push em `main` e tags `v*`; PRs só compilam).

## Deploy numa máquina real

Partir de qualquer Fedora Atomic (Kinoite/Silverblue) ou do
[ublue main](https://universal-blue.org/images/):

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/<owner>/glitch-os:latest
systemctl reboot
```

Rollback (a qualquer momento):

```bash
rpm-ostree rollback   # ou selecionar no menu de boot
```

## O que validar após deploy

- [ ] SDDM com tema `glitch-os` (Wayland)
- [ ] `glitch-doctor` — sem FAIL
- [ ] `glitch-perf ultra` / `battery` mudam governor + perfil ppd
- [ ] Steam arranca; `glitch-game --hud <jogo>` ativa GameMode + MangoHud
- [ ] variante nvidia: `nvidia-smi` OK, PRIME funciona em híbridos
- [ ] `rpm-ostree rebase` → update → `rpm-ostree rollback` sem dados perdidos
- [ ] zram ativo (`swapon --show`)

## Nota: protótipo Arch

O protótipo inicial (archiso) está arquivado em `legacy/arch-prototype/`.
Decisão de base registada em `docs/SPEC.md`.
