# 🩸 GLITCH OS — Fedora Atomic image (universal-blue model)
#
# Variantes via BASE_IMAGE:
#   main:   ghcr.io/ublue-os/kinoite-main:latest
#   nvidia: ghcr.io/ublue-os/kinoite-nvidia:latest
ARG BASE_IMAGE=ghcr.io/ublue-os/kinoite-main:latest
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.title="GLITCH OS" \
      org.opencontainers.image.description="ULTRA PERFORMANCE - GAMING - TERROR" \
      org.opencontainers.image.vendor="GLITCH OS"

# RPM Fusion (steam, wine, etc.)
RUN dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf clean all

# Pacotes GLITCH (listas em packages/, dnf names)
COPY packages /tmp/glitch-packages
RUN dnf install -y --setopt=install_weak_deps=False \
        $(cat /tmp/glitch-packages/*.list | grep -vE '^\s*(#|$)' | sort -u) && \
    rm -rf /tmp/glitch-packages && \
    dnf clean all

# GLITCH Engine + tema + configs do sistema
COPY config/files /
RUN chmod 755 /usr/bin/glitch-* /etc/skel/.config/plasma-workspace/env/glitch-env.sh && \
    systemctl enable glitch-engine.service systemd-zram-generator@zram0.service
