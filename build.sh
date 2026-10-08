#!/usr/bin/env bash
# GLITCH OS — build da imagem OCI (Fedora Atomic / universal-blue)
# Uso: ./build.sh [main|nvidia]   (default: main)
set -euo pipefail

VARIANT="${1:-main}"
REGISTRY="${REGISTRY:-ghcr.io}"
IMAGE_NAME="${IMAGE_NAME:-glitch-os}"
VERSION="${VERSION:-$(date +%Y%m%d)}"

if command -v podman >/dev/null 2>&1; then BUILDER=podman
elif command -v docker >/dev/null 2>&1; then BUILDER=docker
else echo "erro: podman ou docker necessário" >&2; exit 1; fi

case "$VARIANT" in
    main)
        BASE_IMAGE="ghcr.io/ublue-os/kinoite-main:stable"
        TAG="${IMAGE_NAME}:${VERSION}"
        ;;
    nvidia)
        BASE_IMAGE="ghcr.io/ublue-os/kinoite-nvidia:stable"
        TAG="${IMAGE_NAME}-nvidia:${VERSION}"
        ;;
    *)
        echo "usage: $0 [main|nvidia]" >&2; exit 1
        ;;
esac

echo "==> GLITCH OS build ($VARIANT)"
echo "    base:  $BASE_IMAGE"
echo "    tag:   $TAG"

$BUILDER build \
    --build-arg BASE_IMAGE="$BASE_IMAGE" \
    --label "org.opencontainers.image.version=$VERSION" \
    -t "$TAG" \
    -t "${IMAGE_NAME}${VARIANT/nvidia/-nvidia}:latest" \
    .

echo ""
echo "████████████████████████████████████"
echo "  BUILD OK: $TAG"
echo ""
echo "  Deploy numa máquina Atomic:"
echo "    rpm-ostree rebase ostree-unverified-registry:$REGISTRY/<owner>/$TAG"
