# 🩸 GLITCH OS

**ULTRA PERFORMANCE • GAMING • TERROR**

Distro Linux **Fedora Atomic** (imagem OCI sobre universal-blue `kinoite`,
KDE Plasma + Wayland), com stack gaming completa e identidade visual
dark/cyber-horror opcional. Modelo Bazzite, experiência própria.

> Filosofia: **nada de tweaks mágicos**. Cada otimização é medida — se aumenta
> latência ou reduz FPS, o GLITCH OS não a aplica.
> **rápido → mensurável → estável → recuperável → compatível → bonito.**

## Pilares

- ⚡ **ULTRA PERFORMANCE** — perfis adaptativos (NORMAL / PERFORMANCE / ULTRA / GAMING / BATTERY)
- 🎮 **GAMING** — Steam/Proton, DXVK/VKD3D, GameMode, Gamescope (opcional), MangoHud, Lutris
- 🩸 **TERROR** — tema GLITCH DARK; modo HORROR UI opcional (v2.0)
- 🔄 **RECUPERÁVEL** — base atomic: updates transacionais + rollback instantâneo

## Estrutura do repositório

```text
.
├── Containerfile           # imagem OCI (base ublue-os/kinoite)
├── build.sh                # build local (podman/docker), variantes main|nvidia
├── packages/               # listas de pacotes dnf (concatenadas no build)
├── config/files/           # overlay do sistema (copiado para / na imagem)
│   ├── usr/bin/glitch-*    # GLITCH Engine (hw, perf, doctor, game, banner)
│   ├── usr/lib/systemd/    # glitch-engine.service
│   ├── usr/share/          # tema: cores KDE, SDDM glitch-os, wallpapers
│   └── etc/                # modprobe, sysctl, zram, sddm, skel
├── docs/
│   ├── CONCEPT.md          # conceito original
│   ├── SPEC.md             # especificação faseada (v1.0 / v2.0 / experimental)
│   ├── SPEC-FULL.md        # lista completa dos 40 blocos
│   └── BUILD.md            # build + deploy + rollback
└── legacy/arch-prototype/  # protótipo inicial archiso (arquivado)
```

## Build & deploy

```bash
./build.sh nvidia      # compila a imagem (qualquer SO com podman/docker)
# na máquina alvo (Fedora Atomic):
rpm-ostree rebase ostree-unverified-registry:ghcr.io/<owner>/glitch-os:latest
```

Detalhes em [docs/BUILD.md](docs/BUILD.md). Guia de teste da primeira versão em [docs/TESTING.md](docs/TESTING.md).

## Estado da roadmap

- [x] Conceito, spec completa (40 blocos) e faseamento v1.0/v2.0/experimental
- [x] Decisão de base: **Fedora Atomic** (universal-blue/kinoite)
- [x] GLITCH Engine v0.2 (`glitch-hw`, `glitch-perf` com EPP/THP/verify/persistência, `glitch-doctor` com Secure Boot/TPM/Steam/Proton/SMART/atomic rollback + `--json`, `glitch-game`, `glitch-banner`)
- [x] Tema GLITCH DARK v0.1 (cores KDE, SDDM QML, wallpaper, banner boot)
- [x] Containerfile + variantes main/nvidia + CI (GHCR)
- [ ] GLITCH Update (snapshot → update → teste → rollback com UI)
- [ ] GLITCH Dashboard / Control Center
- [ ] GLITCH Game Center (biblioteca única)
- [ ] Benchmark Lab (validação antes/depois de cada otimização)
- [ ] HORROR UI mode
- [ ] Recovery menu
