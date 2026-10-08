# GLITCH OS — Conceito

**ULTRA PERFORMANCE • GAMING • TERROR**

Não é "mais uma distro Linux gaming". É um Linux com identidade **sombria, agressiva e
cinematográfica**, mas tecnicamente sério.

## Arquitetura

```text
                    GLITCH OS
                        │
        ┌───────────────┼────────────────┐
        │               │                │
     GAMING          DESKTOP           TERROR
        │               │                │
   Steam/Proton       KDE Plasma      Dark UI
   DXVK/VKD3D         Wayland         Horror theme
   Gamescope          PipeWire        Horror sounds*
   GameMode           Files           Glitch effects
   Vulkan             Browser         Dark wallpapers
        │               │                │
        └───────────────┼────────────────┘
                        │
                  GLITCH ENGINE
                        │
             Performance Manager
             Hardware Manager
             System Doctor
             Game Optimizer
                        │
                     systemd
                        │
                   Linux Kernel
```

\* Sons/efeitos opcionais e fáceis de desligar.

## ⚡ Performance adaptativa

Perfis em vez de forçar tudo para máximo:

| Perfil        | Uso                              |
|---------------|----------------------------------|
| NORMAL        | Uso diário                       |
| PERFORMANCE   | Aplicações pesadas               |
| ULTRA         | Prioridade máxima ao desempenho  |
| GAMING        | Automático ao lançar jogos       |
| BATTERY       | Portátil/economia                |

O Gaming Mode usa **Gamescope quando faz sentido**, mas não obriga todos os jogos a
passar por ele — sessões aninhadas têm overhead e alguns jogos comportam-se pior.
(VRR, HDR, resolução e isolamento são os casos em que compensa.)

Base: **Wayland + KDE Plasma**. Wayland no Plasma já compete com X11 para gaming,
embora o comportamento dependa do jogo/GPU/configuração.

## 🎮 Stack gaming

```text
Linux Kernel → GPU Driver → Vulkan/OpenGL → Proton → DXVK/VKD3D-Proton → Game
```

Componentes integrados/opcionais: GameMode, Gamescope, MangoHud, Steam, Heroic, Lutris.

## 🩸 Terror = identidade (não desconforto)

O sistema **não é assustador por defeito**.

### GLITCH DARK

- preto quase absoluto, vermelho profundo
- pequenos glitches, animações discretas
- tipografia monoespaçada
- CRT/scanlines opcionais, ícones lineares, wallpapers dark

Banner de boot:

```text
████████████████████
      GLITCH OS
  SYSTEM ONLINE
  GPU ........ OK
  CPU ........ OK
  NETWORK .... OK
  SECURITY ... OK
████████████████████
```

### HORROR UI

Modo opcional que transforma o desktop numa experiência muito mais cinematográfica.

## 🖥️ Desktop

- **Esquerda**: Firefox, Files, App Store, Steam, Performance, Optimize Center, System Info, Settings, System Doctor
- **Direita**: Home, Downloads, Documents, Pictures
- **Centro**: completamente livre por defeito

GLITCH Dashboard:

```text
┌──────────────────────────────────────┐
│ GLITCH OS                            │
│ CPU       41%        58°C            │
│ GPU       72%        61°C            │
│ RAM       11.2 GB                    │
│ FPS       144                        │
│ PERFORMANCE: ULTRA                   │
│ [ GAME MODE ]     [ OPTIMIZE ]       │
└──────────────────────────────────────┘
```

## 🔥 Hardware adaptativo

O GLITCH OS deteta o hardware e configura-se:

- **NVIDIA**: driver proprietário, `nvidia-drm.modeset=1`, validação Vulkan, VRR/HDR detect, perfil gaming
- **AMD**: Mesa/RADV, Vulkan, perfil gaming
- **Híbrido (iGPU+dGPU)**: Hybrid Graphics Manager — desktop na iGPU, jogos na dGPU (prime-run / switcheroo)

## Princípio fundamental

> **Otimização medida, não mágica.** Se uma alteração aumenta a latência ou reduz FPS,
> o GLITCH OS simplesmente não a aplica.
