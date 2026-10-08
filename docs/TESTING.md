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

> **Nota:** as referências Docker têm de estar em minúsculas — mesmo que o
> utilizador GitHub tenha maiúsculas (`VskiVski`), a imagem é
> `ghcr.io/vskivski/glitch-os`. O workflow já trata disso automaticamente.

## Passo 1.5 — Tornar os packages públicos (obrigatório)

**Repo público ≠ package público.** Quando o primeiro push é feito com o repo
privado, o GitHub cria os container packages como **privados**, e torná-los
públicos não acontece automaticamente ao mudar a visibilidade do repo.
Sem isto, a VM recebe `401/DENIED` no pull anónimo.

Para cada package (`glitch-os` e `glitch-os-nvidia`):

1. Abrir `https://github.com/<user>/glitch-os` → barra lateral direita → **Packages**
2. Clicar no package → **Package settings** (abaixo, à direita)
3. **Danger Zone** → **Change visibility** → `Public` → confirmar

Verificar sem autenticação (a partir de qualquer máquina):

```bash
curl -s "https://ghcr.io/token?service=ghcr.io&scope=repository:<user>/glitch-os:pull"
# package público → devolve {"token":"..."}
# package privado → devolve {"errors":[{"code":"DENIED",...}]}
```

(Alternativa ao Passo 1.5: re-trigger do workflow — `workflow_dispatch` ou um
commit vazio — *depois* do repo já ser público; packages criados por push com o
repo público nascem públicos.)

## Passo 2 — Preparar a máquina de teste

Instalar Fedora Kinoite (ou qualquer Fedora Atomic KDE):
- VM: descarregar o ISO de https://fedoraproject.org/atomic-desktops/kinoite
- Instalar normal, criar utilizador, reboot

## Passo 3 — Rebase para o GLITCH OS

```bash
# permite imagens sem assinatura (dev); user em minúsculas
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

## Troubleshooting

**`401`/`DENIED` no pull anónimo (rpm-ostree rebase falha):**
o package é privado (ver Passo 1.5) ou o nome está errado. Confirmar:

```bash
# token anónimo — {"token":...} significa público e acessível
curl -s "https://ghcr.io/token?service=ghcr.io&scope=repository:<user>/glitch-os:pull"

# referência correta é sempre em minúsculas
curl -s "https://ghcr.io/v2/<user>/glitch-os/tags/list" \
  -H "Authorization: Bearer $(curl -s "https://ghcr.io/token?service=ghcr.io&scope=repository:<user>/glitch-os:pull" | jq -r .token)"
```

Se `Packages` na página do repo aparecer vazio mas o Actions estiver verde:
os packages existem mas estão privados — só visíveis em
`https://github.com/<user>?tab=packages` quando autenticado.

**Workflow falha em segundos no build:** tag da base inexistente. As bases são
`ghcr.io/ublue-os/kinoite-main:latest` e `kinoite-nvidia:latest` (não existe
tag `stable`).

## Reportar problemas

Registo útil para diagnóstico:
```bash
glitch-doctor --json > doctor.json
journalctl -b -u glitch-engine > engine.log
rpm-ostree status > ostree.txt
```
