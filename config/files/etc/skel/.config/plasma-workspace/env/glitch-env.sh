#!/bin/sh
# GLITCH OS — session env
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_TYPE=wayland
# GameMode aplica governor/nice por jogo; mangohud só quando pedido (MANGOHUD=1)
export __GL_GSP_ALLOWED=1
