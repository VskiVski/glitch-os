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

# RPM Fusion + Pacotes GLITCH + GLITCH Engine config
RUN dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf clean all && \
    dnf install -y --setopt=install_weak_deps=False \
        $(find /tmp/glitch-packages -type f -name "*.list" -exec cat {} \; 2>/dev/null | grep -vE '^\s*(#|$)' | sort -u) && \
    dnf clean all

COPY packages /tmp/glitch-packages
COPY config/files /

RUN chmod 755 /usr/bin/glitch-* /etc/skel/.config/plasma-workspace/env/glitch-env.sh && \
    systemctl enable glitch-engine.service systemd-zram-generator@zram0.service
