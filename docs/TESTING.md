# TESTING — como testar a primeira versão do GLITCH OS

A imagem é OCI (Fedora Atomic). Não precisas de a compilar nesta máquina —
o GitHub Actions compila-a. Precisas de:

1. Uma conta GitHub (para o CI compilar a imagem)
2. Uma máquina de teste: **PC real** ou **VM** (VirtualBox/VMware/Hyper-V) com
   Fedora Kinoite instalado — a VM chega para validar quase tudo (2 CPU, 8 GB RAM, 40 GB)

## Passo 1 — Publicar e compilar (CI)

```bash
# repo local já tem git init + commit; cria um repo vazio no GitHub e:
git remote add origin https://github.com/<user>/glitch-os.git
git push -u origin main
```

O workflow `image.yml` corre shellcheck + build das variantes `main` e `nvidia`
e publica em `ghcr.io/<user>/glitch-os:latest` e `glitch-os-nvidia:latest`.
(Primeiro push: verificar em Actions se o build passou; nomes de pacotes dnf
inválidos aparecem aqui.)

## Passo 2 — Preparar a máquina de teste

Instalar Fedora Kinoite (ou qualquer Fedora Atomic KDE):
- VM: descarregar o ISO de https://fedoraproject.org/atomic-desktops/kinoite
- Instalar normal, criar utilizador, reboot

## Passo 3 — Rebase para o GLITCH OS

```bash
# permite imagens sem assinatura (dev)
rpm-ostree rebase ostree-unverified-registry:ghcr.io/<user>/glitch-os:latest
systemctl reboot
```

## Passo 4 — Checklist de teste v0.1

Boot e identidade:
- [ ] SDDM aparece com tema `glitch-os` (fundo preto, vermelho, mono)
- [ ] Login → Plasma com esquema GlitchDark e wallpaper glitch-dark
- [ ] Consola mostra cores do tema

GLITCH Engine:
- [ ] `glitch-doctor` — sem FAIL (WARN aceitáveis em VM: Secure Boot, TPM, GPU)
- [ ] `glitch-doctor --json | jq .` — JSON válido
- [ ] `glitch-hw` — escreve `/etc/glitch/hardware.conf` com GPU/CPU corretos
- [ ] `glitch-perf status` — mostra PROFILE/GOVERNOR/EPP/THP/PPD
- [ ] `glitch-perf ultra --save` → reboot → `glitch-perf status` mantém ULTRA
- [ ] `glitch-perf auto` em bateria (VM: skip) 
- [ ] `systemctl status glitch-engine` — ativo, sem erros
- [ ] `glitch-banner` — imprime SYSTEM ONLINE

Atomic/rollback:
- [ ] `rpm-ostree status` — 2 deployments (Kinoite + GLITCH OS)
- [ ] `rpm-ostree rollback && systemctl reboot` → volta a Kinoite
- [ ] rebase de novo para GLITCH OS

Gaming (em PC real com GPU, não VM):
- [ ] Steam arranca e atualiza
- [ ] `glitch-game --hud <jogo>` — GameMode ativo + MangoHud visível
- [ ] variante nvidia: `nvidia-smi` OK

## Regressão a qualquer momento

```bash
rpm-ostree rollback   # ou escolher o deployment anterior no menu de boot
```

## Reportar problemas

Registo útil para diagnóstico:
```bash
glitch-doctor --json > doctor.json
journalctl -b -u glitch-engine > engine.log
rpm-ostree status > ostree.txt
```
