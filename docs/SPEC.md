# GLITCH OS — Especificação Técnica (faseada)

Lista completa de requisitos em [SPEC-FULL.md](SPEC-FULL.md) (40 blocos).
Este documento separa o que é **v1.0 obrigatório**, **v2.0** e **experimental**,
para não construir tudo ao mesmo tempo.

Regra principal: **rápido → mensurável → estável → recuperável → compatível → bonito.**

## Decisão de base: Fedora Atomic ✅ (2026-10-08)

**Escolhido: Fedora Atomic sobre universal-blue (`ublue-os/kinoite`)**, modelo Bazzite —
updates transacionais, rollback nativo, Secure Boot de base, layering NVIDIA via akmods
(variante `kinoite-nvidia`). O desenvolvimento próprio concentra-se na experiência:
GLITCH Engine, tema, Game Center, Dashboard, Benchmark Lab.

| | Arch (protótipo) | **Fedora Atomic (escolhido)** |
|---|---|---|
| Updates | pacman rolling | transacionais (rpm-ostree), imagem completa |
| Rollback | manual (Btrfs+snapper/btrbk) | nativo, instantâneo |
| Secure Boot | chaves próprias, trabalhoso | suportado de base |
| Drivers NVIDIA | repos + dkms | layering/akmods (modelo Bazzite) |
| Freshness gaming | máxima | muito boa (uBlue images) |
| Esforço próprio | tudo desde o zero (archiso) | herda infra madura (universal-blue) |

O protótipo archiso ficou arquivado em `legacy/arch-prototype/`.

## v1.0 — obrigatório (ISO instalável e fiável)

**Base/sistema** (bloco 1, 15, 17, 25)
- [ ] x86_64, UEFI, Secure Boot, systemd, microcode AMD+Intel
- [ ] kernel moderno + opção LTS; zram; initramfs otimizado
- [ ] Btrfs (snapshots, compressão, subvolumes) ou base atomic equivalente
- [ ] snapshot automático antes de updates + restauro
- [ ] dual-boot Windows seguro (os-prober, avisos claros, não destrói partições)
- [ ] firewall + permissões corretas + zero telemetria obrigatória

**Performance/kernel** (bloco 2, 8)
- [ ] AMD P-State / Intel P-State / EPP; CPUs híbridas
- [ ] perfis: NORMAL / PERFORMANCE / ULTRA / GAMING / BATTERY — `glitch-perf` ✔ (v0.1)
- [ ] otimização medida: nenhuma alteração entra sem benchmark antes/depois

**GPU/display** (blocos 3, 4)
- [ ] AMD (RADV/Mesa), NVIDIA (proprietário + PRIME/Optimus), Intel (ANV) — `glitch-hw` ✔ (v0.1)
- [ ] Wayland + XWayland; VRR/FreeSync/G-Sync; HDR; multi-monitor alta frequência
- [ ] escalamento fracionado, Night Light

**Gaming** (blocos 5, 28)
- [ ] Steam + Steam Play/Proton (+ Proton-GE opcional), DXVK, VKD3D-Proton
- [ ] GameMode, Gamescope (opcional, nunca obrigatório), MangoHud, vkBasalt
- [ ] shader pre-caching; controllers Xbox/PS/Switch/Steam (Steam Input)

**Desktop** (blocos 13, 14, 19, 21, 27)
- [ ] KDE Plasma 6 Wayland, Dolphin, Discover, KDE Connect
- [ ] PipeWire + WirePlumber (Pulse/ALSA compat, BT audio, volumes por app)
- [ ] NetworkManager (Wi-Fi/Ethernet/BT/VPN/hotspot)
- [ ] Firefox, VLC, gestor de ficheiros/arquivos/PDF, screenshots

**Identidade** (blocos 22, 23)
- [ ] tema GLITCH DARK (cores ✔, SDDM ✔, wallpaper ✔, banner ✔)
- [ ] níveis NORMAL / DARK — HORROR fica para v2.0
- [ ] tudo desligável

**Ferramentas próprias v1** (blocos 9, 10, 11, 16)
- [x] `glitch-doctor` v0.2 — Kernel, Secure Boot, TPM, GPU, Vulkan, Steam/Proton/Wine, GameMode, Gamescope, zram, disco, SMART, rede, áudio, Bluetooth, serviços, atomic rollback, térmico + `--json`
- [ ] `glitch-hw` ✔ (v0.1) — expandir para Hardware Center (CPU/GPU/RAM/storage/bateria)
- [ ] GLITCH Update: snapshot → update → teste → rollback
- [ ] i18n: pt-PT, en (base)

**Qualidade** (blocos 38, 39)
- [ ] Wiki (instalação, drivers, recovery, dual-boot, troubleshooting)
- [ ] CI: build ISO ✔ + teste de boot QEMU automatizado

## v2.0 — diferencial

- [ ] **GLITCH Game Center** (bloco 6): biblioteca única Steam/Epic/GOG/itch/local
- [ ] **Game Mode consola** (bloco 7): sessão Gamescope dedicada, overlay FPS/temp/frametime/1% lows, sair para desktop
- [ ] **GLITCH Dashboard / Control Center** (blocos 8, 24): painel único com métricas + modo + display + rede + áudio
- [ ] **Benchmark Lab** (bloco 33): CPU/GPU/mem/storage/Vulkan/rede, scores guardados, comparar otimizações
- [ ] **Optimize Center** (bloco 9): explica o que vai mudar antes de aplicar; só aplica o que o benchmark validar
- [ ] **Laptop Mode** (bloco 12): dGPU on-demand, brilho, suspensão/hibernação, autonomia
- [ ] **HORROR UI** (bloco 23): terceiro nível cinematográfico (NO SIGNAL / SIGNAL RESTORED), sem prejudicar uso
- [ ] **Recovery menu** (bloco 26): safe mode, restore snapshot, repair boot, reset
- [ ] **GLITCH Store** (bloco 18): Flatpak + nativos, permissões visíveis
- [ ] Streaming/criação (bloco 20): OBS + NVENC/VA-API/Quick Sync pré-configurados
- [ ] Dev (bloco 30): distrobox/podman, toolchains
- [ ] Manutenção automática (bloco 34): caches, scrub Btrfs, snapshots antigos
- [ ] Acessibilidade completa (bloco 37); mais idiomas (bloco 36)

## Experimental

- [ ] **GLITCH AI** (bloco 31): assistente que cruza sintomas com o System Doctor; só leitura primeiro, nunca altera sem autorização
- [ ] **Compatibility Center** (bloco 32): estimativas ProtonDB — sempre marcadas como estimativa
- [ ] NTsync/futex melhorados, kernel próprio com patches (fsync) quando justificado por medição
- [ ] ROCm; emulação/ROMs; DisplayLink; animações boot/shutdown próprias
- [ ] telemetria opcional (opt-in, cada dado explicado)

## Os 7 sistemas próprios → estado do repo

| Sistema | Bloco | Estado |
|---|---|---|
| GLITCH Performance | 8 | `glitch-perf` v0.1 (perfis) — falta benchmark lab |
| GLITCH Game Center | 6 | v2.0 |
| GLITCH System Doctor | 10 | `glitch-doctor` v0.1 — expandir na v1.0 |
| GLITCH Hardware Center | 11 | `glitch-hw` v0.1 (deteção) — UI na v2.0 |
| GLITCH Update | 16 | v1.0 (snapshot/rollback) |
| GLITCH AI | 31 | experimental |
| GLITCH Experience | 22–24 | tema v0.1 ✔ (cores, SDDM, wallpaper, banner) |
